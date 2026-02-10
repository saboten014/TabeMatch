package tabematch.admin;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Shop;
import bean.Users;
import dao.ShopDAO;
import dao.UserDAO;
import tool.Action;
import util.PasswordGenerator;

public class AdminShopInsertExecuteAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        req.setCharacterEncoding("UTF-8");

        // 1. パラメータ取得
        String password = req.getParameter("password");
        String restaurantName = req.getParameter("restaurantName");
        String address = req.getParameter("address");
        String request_mail = req.getParameter("request_mail");
        String number = req.getParameter("number");
        String link = req.getParameter("link");
        String genre = req.getParameter("genre");
        String priceRange = req.getParameter("priceRange");
        String payment = req.getParameter("payment");
        String seat = req.getParameter("seat");
        String reservationStr = req.getParameter("reservation");
        // ★追加：JSPで入力した営業時間を受け取る
        String businessHours = req.getParameter("businessHours");

        // 2. アレルギー情報を取得
        String[] allergyArray = req.getParameterValues("allergyInfo");
        String allergySupport = (allergyArray != null) ? String.join(",", allergyArray) : "";

        // 3. データの加工
        String shopReserve = "不可";
        if ("1".equals(reservationStr)) {
            shopReserve = "可能";
        }

        Integer shopSeat = extractSeatNumber(seat);
        String shopId = PasswordGenerator.generateShopId();

        // 4. Shopオブジェクトの作成
        Shop shop = new Shop();
        shop.setShopId(shopId);
        shop.setPassword(password);
        shop.setShopName(restaurantName);
        shop.setShopAddress(address);
        shop.setShopMail(request_mail);
        shop.setShopTel(number);
        shop.setShopUrl(link);
        shop.setShopGenre(genre);
        shop.setShopPrice(priceRange);
        shop.setShopPay(payment);
        shop.setShopSeat(shopSeat);
        shop.setShopReserve(shopReserve);
        shop.setShopAllergy(allergySupport);
        // ★追加：営業時間をセット（フィールド名はShop Beanに合わせて調整してください）
        shop.setShopTime(businessHours);
        shop.setIsPublic(true);

        // 5. Usersオブジェクトの作成
        Users shopUser = new Users();
        shopUser.setUserId(request_mail);
        shopUser.setPassword(password);
        shopUser.setUserName(restaurantName);
        shopUser.setUsersTypeId("2");
        shopUser.setAllergenId(allergySupport);

        ShopDAO shopDao = new ShopDAO();
        UserDAO userDao = new UserDAO();

        try {
            // トランザクション制御がない場合、User登録後にShop登録が失敗するとデータが不整合になるため注意
            boolean userCreated = userDao.registerUser(shopUser);

            if (!userCreated) {
                req.setAttribute("errorMessage", "ユーザーアカウントの作成に失敗しました（既に登録されているメールアドレスの可能性があります）。");
                // JSPのファイル名に合わせて修正してください
                req.getRequestDispatcher("admin-shop-insert-form.jsp").forward(req, res);
                return;
            }

            boolean shopCreated = shopDao.insertShopForAdmin(shop);

            if (!shopCreated) {
                req.setAttribute("errorMessage", "店舗情報の登録に失敗しました。");
                req.getRequestDispatcher("admin-shop-insert-form.jsp").forward(req, res);
                return;
            }

            // 成功時の処理
            req.setAttribute("successMessage", "店舗「" + restaurantName + "」の登録が完了しました。");
            req.setAttribute("shopId", shopId);

            // パスはプロジェクトの構造に合わせて調整してください
            req.getRequestDispatcher("admin-shop-insert-complete.jsp").forward(req, res);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "システムエラーが発生しました: " + e.getMessage());
            req.getRequestDispatcher("admin-shop-insert-form.jsp").forward(req, res);
        }
    }

    private int extractSeatNumber(String seatInfo) {
        if (seatInfo == null || seatInfo.isEmpty()) return 0;
        String[] numbers = seatInfo.replaceAll("[^0-9]", " ").trim().split("\\s+");
        int total = 0;
        for (String num : numbers) {
            if (!num.isEmpty()) {
                try {
                    total += Integer.parseInt(num);
                } catch (NumberFormatException e) { /* Ignore */ }
            }
        }
        return total;
    }
}