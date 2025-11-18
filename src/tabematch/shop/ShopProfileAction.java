package tabematch.shop;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Shop;
import bean.Users; // ログインユーザーの情報（IDとタイプ）を保持していると仮定
import dao.ShopDAO;
import tool.Action;

@WebServlet("/ShopProfile.action")
public class ShopProfileAction extends Action {

    @Override

    public void execute(HttpServletRequest req, HttpServletResponse res)
            throws Exception {

        // 1. セッションと変数の準備
        HttpSession session = req.getSession();
        ShopDAO shopDao = new ShopDAO();
        String url = "";

        // 2. ログインチェックと権限チェック
        Users user = (Users) session.getAttribute("user");
        System.out.println(user);

        // ログインしていない場合 または ユーザータイプが店舗管理者(ID:'2')でない場合
        if (user == null || !"2".equals(user.getUsersTypeId())) {
            req.setAttribute("errorMessage", "店舗管理者としてログインしてください。");
            // ログイン画面へリダイレクト（絶対パス推奨）
            req.getRequestDispatcher("/login.jsp").forward(req, res);
            return;
        }

        String shopMail = user.getUserId();
        System.out.println(shopMail);

        // 4. DAOを使用して店舗情報を取得
        Shop shop = shopDao.getShopByMail(shopMail);
        //中身に以上が無いか確認
        System.out.println(shop);

        // 5. 取得結果の確認とJSPへのフォワード
        if (shop != null) {
            // 情報をリクエストスコープに格納
            req.setAttribute("shop_profile", shop);
            // 店舗プロフィール表示用のJSPへ遷移
            url = "/tabematch/shop/shop-profile.jsp";
        } else {
            // 店舗情報が見つからない（データ異常など）
            req.setAttribute("errorMessage", "店舗IDが見つかりません。データ管理者へお問い合わせください。");
            // エラー画面または店舗管理メニュー画面へ遷移
            url = "/error.jsp";
        }

        // 6. JSPへフォワード
        req.getRequestDispatcher(url).forward(req, res);
    }
}