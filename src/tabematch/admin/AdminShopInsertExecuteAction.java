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

        // ★パラメータ取得（shop-request.jspのname属性に統一）
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

        // ★アレルギー情報をチェックボックスから取得（allergenNameが入る）
        String[] allergyArray = req.getParameterValues("allergyInfo");
        String allergySupport = (allergyArray != null) ? String.join(",", allergyArray) : "";

        // ★予約可否の変換（1=可能, 2=不可 → "可能"/"不可"）
        String shopReserve = "不可";
        if (reservationStr != null && reservationStr.equals("1")) {
            shopReserve = "可能";
        }

        // ★座席数の抽出（AdminRequestApproveActionと同じ処理）
        Integer shopSeat = extractSeatNumber(seat);

        // ★店舗IDを自動生成
        String shopId = PasswordGenerator.generateShopId();

        // 1. 店舗情報を作成
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
        shop.setIsPublic(true);

        // 2. 店舗ユーザーアカウントを作成
        Users shopUser = new Users();
        shopUser.setUserId(request_mail);       // メールアドレスをuserIdに
        shopUser.setPassword(password);         // 管理者が入力したパスワード
        shopUser.setUserName(restaurantName);   // 店舗名をユーザー名に
        shopUser.setUsersTypeId("2");           // 店舗ユーザー

        shopUser.setAllergenId(allergySupport);

        // 3. DAOで登録
        ShopDAO shopDao = new ShopDAO();
        UserDAO userDao = new UserDAO();

        try {
            // ★ユーザーアカウントを先に作成
            boolean userCreated = userDao.registerUser(shopUser);

            if (!userCreated) {
                req.setAttribute("errorMessage", "ユーザーアカウントの作成に失敗しました。");
                req.getRequestDispatcher("admin-shop-insert-form.jsp").forward(req, res);
                return;
            }

            // ★店舗情報を登録
            boolean shopCreated = shopDao.insertShopForAdmin(shop);

            if (!shopCreated) {
                req.setAttribute("errorMessage", "店舗情報の登録に失敗しました。");
                req.getRequestDispatcher("admin-shop-insert-form.jsp").forward(req, res);
                return;
            }

            // 成功
            req.setAttribute("successMessage", "店舗とユーザーアカウントを登録しました。");
            req.setAttribute("shopId", shopId);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "登録中にエラーが発生しました: " + e.getMessage());
            req.getRequestDispatcher("admin-shop-insert-form.jsp").forward(req, res);
            return;
        }

        req.getRequestDispatcher("/tabematch/admin/admin-shop-insert-complete.jsp").forward(req, res);
    }

    // ★座席情報から数字を抽出するヘルパーメソッド（AdminRequestApproveActionと同じ）
    private int extractSeatNumber(String seatInfo) {
        if (seatInfo == null || seatInfo.isEmpty()) {
            return 0;
        }

        // 数字を抽出して合計
        String[] numbers = seatInfo.replaceAll("[^0-9]", " ").trim().split("\\s+");
        int total = 0;
        for (String num : numbers) {
            if (!num.isEmpty()) {
                try {
                    total += Integer.parseInt(num);
                } catch (NumberFormatException e) {
                    // 無視
                }
            }
        }
        return total;
    }
}