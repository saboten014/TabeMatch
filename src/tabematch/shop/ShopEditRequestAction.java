package tabematch.shop;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Shop;
import bean.Users;
import dao.ShopDAO;
import tool.Action;

public class ShopEditRequestAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res)
            throws Exception {

        HttpSession session = req.getSession();
        String url = "";

        // 1. ログインチェックと権限チェック
        Users user = (Users) session.getAttribute("user");

        if (user == null || !"2".equals(user.getUsersTypeId())) {
            req.setAttribute("errorMessage", "店舗管理者としてログインしてください。");
            req.getRequestDispatcher("/tabematch/login.jsp").forward(req, res);
            return;
        }

        String shopMail = user.getUserId();

        // 2. 現在の店舗情報を取得
        ShopDAO shopDao = new ShopDAO();
        Shop shop = shopDao.getShopByMail(shopMail);

        if (shop == null) {
            req.setAttribute("errorMessage", "店舗情報が取得できませんでした。");
            req.getRequestDispatcher("/error.jsp").forward(req, res);
            return;
        }

        // 3. 編集フォームを表示 or 編集リクエストを送信
        String mode = req.getParameter("mode");

        if (mode == null || mode.equals("form")) {
            // フォーム表示
            req.setAttribute("shop", shop);
            url = "/tabematch/shop/shop-edit-request-form.jsp";

        } else if (mode.equals("submit")) {
            // 編集リクエスト送信処理
            String shopName = req.getParameter("shopName");
            String shopAddress = req.getParameter("shopAddress");
            String shopTel = req.getParameter("shopTel");
            String shopUrl = req.getParameter("shopUrl");
            String shopAllergy = req.getParameter("shopAllergy");
            String shopGenre = req.getParameter("shopGenre");
            String shopPrice = req.getParameter("shopPrice");
            String shopPay = req.getParameter("shopPay");
            String shopSeatStr = req.getParameter("shopSeat");
            String shopReserve = req.getParameter("shopReserve");
            String requestNote = req.getParameter("requestNote");

            // バリデーション
            if (shopName == null || shopName.trim().isEmpty() ||
                shopAddress == null || shopAddress.trim().isEmpty() ||
                shopTel == null || shopTel.trim().isEmpty()) {

                req.setAttribute("errorMessage", "必須項目を入力してください。");
                req.setAttribute("shop", shop);
                url = "/tabematch/shop/shop-edit-request-form.jsp";
                req.getRequestDispatcher(url).forward(req, res);
                return;
            }

            // 座席数の変換
            Integer shopSeat = null;
            if (shopSeatStr != null && !shopSeatStr.trim().isEmpty()) {
                try {
                    shopSeat = Integer.parseInt(shopSeatStr);
                } catch (NumberFormatException e) {
                    req.setAttribute("errorMessage", "座席数は数値で入力してください。");
                    req.setAttribute("shop", shop);
                    url = "/tabematch/shop/shop-edit-request-form.jsp";
                    req.getRequestDispatcher(url).forward(req, res);
                    return;
                }
            }

            // ★ここで編集リクエストをDBに保存する処理を実装
            // 今回は簡易的にセッションに保存し、管理者が確認する想定
            session.setAttribute("editRequestShopId", shop.getShopId());
            session.setAttribute("editRequestData", "店舗名: " + shopName +
                "\n住所: " + shopAddress +
                "\n電話: " + shopTel +
                "\nURL: " + shopUrl +
                "\nアレルギー対応: " + shopAllergy +
                "\nジャンル: " + shopGenre +
                "\n価格帯: " + shopPrice +
                "\n決済方法: " + shopPay +
                "\n座席数: " + shopSeat +
                "\n予約可否: " + shopReserve +
                "\n備考: " + requestNote);

            session.setAttribute("successMessage", "編集リクエストを送信しました。管理者による承認をお待ちください。");
            url = "/tabematch/shop/shop-edit-request-complete.jsp";
        }

        req.getRequestDispatcher(url).forward(req, res);
    }
}