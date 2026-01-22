package tabematch.admin;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Request;
import bean.Shop;
import bean.Users;
import dao.RequestDAO;
import dao.ShopDAO;
import dao.UserDAO;
import tool.Action;
import util.EmailSender;
import util.PasswordGenerator;

public class AdminRequestApproveAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res)
            throws Exception {

        String url = "";
        HttpSession session = req.getSession();
        RequestDAO requestDao = new RequestDAO();
        UserDAO userDao = new UserDAO();
        ShopDAO shopDao = new ShopDAO();

        // 1. リクエストパラメータの取得
        String requestId = req.getParameter("requestId");

        // 2. 権限チェックとバリデーション
        Users admin = (Users)session.getAttribute("user");
        if (admin == null || !"3".equals(admin.getUsersTypeId())) {
            req.setAttribute("errorMessage", "管理者権限が必要です。");
            url = "../login.jsp";
            req.getRequestDispatcher(url).forward(req, res);
            return;
        }

        if (requestId == null || requestId.trim().isEmpty()) {
            req.setAttribute("errorMessage", "リクエストIDが指定されていません。");
            url = "AdminRequestList.action";
            req.getRequestDispatcher(url).forward(req, res);
            return;
        }

        // 3. データの取得と状態確認
        Request request = requestDao.getRequestById(requestId);

        if (request == null) {
            req.setAttribute("errorMessage", "リクエストが見つかりませんでした。");
            url = "AdminRequestList.action";
        } else if (request.getCertification() != 1) { // 1=未処理
            req.setAttribute("errorMessage", "このリクエストは既に承認または却下されています。");
            url = "AdminRequestList.action";
        } else {
            // 4. 重複チェック（ここが重要！）
            String shopEmail = request.getRequest_mail();

            // すでにUSERSテーブルに登録されていないか確認
            if (userDao.isEmailExists(shopEmail)) {
                req.setAttribute("errorMessage", "このメールアドレス（" + shopEmail + "）は既に登録されているため承認できません。");
                url = "AdminRequestList.action";
            } else {

                // 5. ビジネスロジック：店舗用データの作成

                // 仮パスワード生成
                String tempPassword = PasswordGenerator.generatePassword();

                // (1) ユーザーアカウント（USERSテーブル）の準備
                Users shopUser = new Users();
                shopUser.setUserId(shopEmail);
                shopUser.setPassword(tempPassword);
                shopUser.setUserName(request.getRestaurantName());
                shopUser.setAllergenId("001"); // デフォルト値
                shopUser.setUsersTypeId("2"); // 店舗ユーザー

                // (2) 店舗情報（SHOPテーブル）の準備
                Shop shop = new Shop();
                shop.setShopId(PasswordGenerator.generateShopId());
                shop.setPassword(tempPassword);
                shop.setShopAddress(request.getAddress());
                shop.setShopName(request.getRestaurantName());
                shop.setShopAllergy(request.getAllergySupport());
                shop.setShopMail(shopEmail);
                shop.setShopTel(request.getNumber().replaceAll("[^0-9]", ""));
                shop.setShopReserve(request.getReservation() == 1 ? "可能" : "不可");
                shop.setShopGenre(request.getGenre());
                shop.setShopPicture(request.getPhoto());
                shop.setShopPrice(request.getPriceRange());
                shop.setShopPay(request.getPayment());
                shop.setShopSeat(extractSeatNumber(request.getSeat()));
                shop.setShopUrl(request.getLink());

                // 6. DBへの一括登録処理（トランザクション管理はDAO側を想定）
                boolean userCreated = userDao.registerUser(shopUser);

                if (userCreated) {
                    boolean shopCreated = shopDao.insertShop(shop);

                    if (shopCreated) {
                        // リクエストを承認済み（2）に更新
                        requestDao.updateCertification(requestId, 2);

                        // 7. メール送信
                        try {
                            EmailSender.sendApprovalEmail(shopEmail, request.getRestaurantName(), shopEmail, tempPassword);
                            req.setAttribute("successMessage", "承認が完了し、店舗「" + request.getRestaurantName() + "」のアカウントを作成しました。");
                        } catch (Exception e) {
                            e.printStackTrace();
                            req.setAttribute("successMessage", "承認は完了しましたが、通知メールの送信に失敗しました。");
                        }
                    } else {
                        req.setAttribute("errorMessage", "SHOPテーブルへの登録に失敗しました。");
                    }
                } else {
                    req.setAttribute("errorMessage", "USERSテーブルへの登録に失敗しました。");
                }
                url = "AdminRequestList.action";
            }
        }

        // 8. 結果画面（一覧）へフォワード
        req.getRequestDispatcher(url).forward(req, res);
    }

    // 座席情報から数字を抽出するヘルパーメソッド
    private int extractSeatNumber(String seatInfo) {
        if (seatInfo == null || seatInfo.isEmpty()) {
            return 0;
        }
        String[] numbers = seatInfo.replaceAll("[^0-9]", " ").trim().split("\\s+");
        int total = 0;
        for (String num : numbers) {
            if (!num.isEmpty()) {
                try {
                    total += Integer.parseInt(num);
                } catch (NumberFormatException e) {
                    // ignore
                }
            }
        }
        return total;
    }
}