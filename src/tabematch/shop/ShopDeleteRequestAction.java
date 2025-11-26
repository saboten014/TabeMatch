package tabematch.shop;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Shop;
import bean.Users;
import dao.ShopDAO;
import tool.Action;

public class ShopDeleteRequestAction extends Action {

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

        // 3. 削除確認画面を表示 or 削除リクエストを送信
        String mode = req.getParameter("mode");

        if (mode == null || mode.equals("confirm")) {
            // 削除確認画面
            req.setAttribute("shop", shop);
            url = "/tabematch/shop/shop-delete-request-confirm.jsp";

        } else if (mode.equals("submit")) {
            // 削除リクエスト送信処理
            String deleteReason = req.getParameter("deleteReason");

            // バリデーション
            if (deleteReason == null || deleteReason.trim().isEmpty()) {
                req.setAttribute("errorMessage", "削除理由を入力してください。");
                req.setAttribute("shop", shop);
                url = "/tabematch/shop/shop-delete-request-confirm.jsp";
                req.getRequestDispatcher(url).forward(req, res);
                return;
            }

            // ★ここで削除リクエストをDBに保存する処理を実装
            // 今回は簡易的にセッションに保存し、管理者が確認する想定
            session.setAttribute("deleteRequestShopId", shop.getShopId());
            session.setAttribute("deleteRequestShopName", shop.getShopName());
            session.setAttribute("deleteRequestReason", deleteReason);

            session.setAttribute("successMessage", "削除リクエストを送信しました。管理者による確認後、アカウントが削除されます。");
            url = "/tabematch/shop/shop-delete-request-complete.jsp";
        }

        req.getRequestDispatcher(url).forward(req, res);
    }
}