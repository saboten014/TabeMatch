package tabematch.shop;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Allergen;
import bean.Shop;
import bean.Users;
import dao.ShopDAO;
import tool.Action;

public class ShopEditRequestAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

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
            // --- フォーム表示 ---
            req.setAttribute("shop", shop);

            // ★DBからアレルギー一覧（マスタ）を取得してリクエストにセット
            List<Allergen> allergenMaster = shopDao.getAllAllergens();
            req.setAttribute("allergenMaster", allergenMaster);

            url = "/tabematch/shop/shop-edit-request-form.jsp";

        } else if (mode.equals("submit")) {
            // --- 編集リクエスト送信処理 ---
            String shopName = req.getParameter("shopName");
            String shopAddress = req.getParameter("shopAddress");
            String shopTel = req.getParameter("shopTel");
            String shopUrl = req.getParameter("shopUrl");
            String shopTime = req.getParameter("shopTime");

            // ★チェックボックス（配列）をカンマ区切りの1本の文字列に合体させる
            String[] allergyArray = req.getParameterValues("shopAllergies");
            String shopAllergy = (allergyArray != null) ? String.join(",", allergyArray) : "";

            String shopGenre = req.getParameter("shopGenre");

            // ★価格帯は単一選択（セレクトボックス）
            String shopPrice = req.getParameter("shopPrice");
            if (shopPrice != null) {
                shopPrice = shopPrice.trim();
            }

            // ★決済方法はテキスト入力から取得
            String shopPay = req.getParameter("shopPay");
            if (shopPay != null) {
                shopPay = shopPay.trim();
            }

            String shopSeatStr = req.getParameter("shopSeat");
            String shopReserve = req.getParameter("shopReserve");
            String requestNote = req.getParameter("requestNote");

            // バリデーション
            if (shopName == null || shopName.trim().isEmpty() ||
                shopAddress == null || shopAddress.trim().isEmpty() ||
                shopTel == null || shopTel.trim().isEmpty() ||
                shopPrice == null || shopPrice.isEmpty() ||  // 価格帯必須チェック
                shopPay == null || shopPay.isEmpty()) {  // 決済方法必須チェック

                req.setAttribute("errorMessage", "必須項目を入力してください。");
                req.setAttribute("shop", shop);
                // 再表示用にもマスタが必要
                req.setAttribute("allergenMaster", shopDao.getAllAllergens());
                url = "/tabematch/shop/shop-edit-request-form.jsp";
                req.getRequestDispatcher(url).forward(req, res);
                return;
            }

            // 座席数の変換
            Integer shopSeat = 0;
            if (shopSeatStr != null && !shopSeatStr.trim().isEmpty()) {
                try {
                    shopSeat = Integer.parseInt(shopSeatStr);
                } catch (NumberFormatException e) {
                    req.setAttribute("errorMessage", "座席数は数値で入力してください。");
                    req.setAttribute("shop", shop);
                    req.setAttribute("allergenMaster", shopDao.getAllAllergens());
                    url = "/tabematch/shop/shop-edit-request-form.jsp";
                    req.getRequestDispatcher(url).forward(req, res);
                    return;
                }
            }

            // DBに編集リクエストを保存
            dao.DAO daoObj = new dao.DAO();
            try (Connection con = daoObj.getConnection()) {
                String requestId = "EDITREQ" + System.currentTimeMillis();
             // SQL文字列の修正（shop_timeを追加）
                String sql = "INSERT INTO shop_edit_requests " +
                             "(request_id, shop_id, shop_name, shop_address, shop_tel, shop_url, " +
                             "shop_allergy, shop_genre, shop_price, shop_pay, shop_seat, shop_reserve, " +
                             "shop_time, request_note, status, created_at) " + // ← shop_timeを追記
                             "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1, CURRENT_TIMESTAMP)"; // ← ?を1つ増やす

                PreparedStatement stmt = con.prepareStatement(sql);
                stmt.setString(1, requestId);
                stmt.setString(2, shop.getShopId());
                stmt.setString(3, shopName);
                stmt.setString(4, shopAddress);
                stmt.setString(5, shopTel);
                stmt.setString(6, shopUrl);
                stmt.setString(7, shopAllergy); // 合体したアレルギー文字列
                stmt.setString(8, shopGenre);
                stmt.setString(9, shopPrice);   // 単一選択の価格帯
                stmt.setString(10, shopPay);    // テキスト入力された決済方法
                stmt.setInt(11, shopSeat);
                stmt.setString(12, shopReserve);
                stmt.setString(13, shopTime);    // 追加した項目のセット（13番目）
                stmt.setString(14, requestNote); // requestNoteが13番から14番にスライド

                int result = stmt.executeUpdate();
                if (result > 0) {
                    session.setAttribute("successMessage", "編集リクエストを送信しました。");
                    url = "/tabematch/shop/shop-edit-request-complete.jsp";
                } else {
                    req.setAttribute("errorMessage", "リクエストの送信に失敗しました。");
                    req.setAttribute("shop", shop);
                    req.setAttribute("allergenMaster", shopDao.getAllAllergens());
                    url = "/tabematch/shop/shop-edit-request-form.jsp";
                }
            }
        }
        req.getRequestDispatcher(url).forward(req, res);
    }
}
