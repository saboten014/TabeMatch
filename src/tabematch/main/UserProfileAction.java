package tabematch.main;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Allergen;
import bean.Users;
import dao.AllergenDAO;
import dao.UserDAO;
import tool.Action;

public class UserProfileAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res)
            throws Exception {
        HttpSession session = req.getSession();
        Users loginUser = (Users) session.getAttribute("user");
        UserDAO dao = new UserDAO();

        // 1. ログインチェック
        if (loginUser == null) {
            req.setAttribute("errorMessage", "ログインが必要です。");
            req.getRequestDispatcher("../login.jsp").forward(req, res);
            return;
        }

        // 店舗ユーザーは別のActionに誘導
        if ("2".equals(loginUser.getUsersTypeId())) {
            res.sendRedirect("ShopProfile.action");
            return;
        }

        String mode = req.getParameter("mode");

        // --- ステップ1: パスワード入力画面の表示 (modeなし) ---
        if (mode == null) {
            req.getRequestDispatcher("user-password-check.jsp").forward(req, res);
            return;
        }

        // --- ステップ2: パスワード認証 (auth) ---
        if (mode.equals("auth")) {
            String inputPass = req.getParameter("password");
            // DBから最新情報を取得して比較
            Users user = dao.getUserById(loginUser.getUserId());

            if (user != null && user.getPassword().equals(inputPass)) {
                // 認証成功 -> 編集用データの準備
                AllergenDAO allergenDao = new AllergenDAO();
                List<Allergen> allergenList = allergenDao.getAllAllergens();
                req.setAttribute("allergenList", allergenList);
                req.setAttribute("user", user);
                req.getRequestDispatcher("user-profile.jsp").forward(req, res);
            } else {
                // 認証失敗
                req.setAttribute("errorMessage", "パスワードが正しくありません。");
                req.getRequestDispatcher("user-password-check.jsp").forward(req, res);
            }
            return;
        }

        // --- ステップ3: プロフィール更新 (update) ---
        if (mode.equals("update")) {
            // 入力値取得
            String userName = req.getParameter("userName");
            String password = req.getParameter("password");
            String confirmPassword = req.getParameter("confirmPassword");
            String userMail = req.getParameter("userMail");
            String[] allergens = req.getParameterValues("allergen");

            // 入力チェック
            if (userName == null || userName.isEmpty() ||
                password == null || password.isEmpty() ||
                userMail == null || userMail.isEmpty()) {
                req.setAttribute("errorMessage", "未入力の項目があります。");
                reloadEditData(req, loginUser);
                req.getRequestDispatcher("user-profile.jsp").forward(req, res);
                return;
            }

            // パスワード一致チェック
            if (!password.equals(confirmPassword)) {
                req.setAttribute("errorMessage", "パスワードが一致しません。");
                reloadEditData(req, loginUser);
                req.getRequestDispatcher("user-profile.jsp").forward(req, res);
                return;
            }

            // Beanの更新
            loginUser.setUserName(userName);
            loginUser.setPassword(password);
            loginUser.setUserId(userMail);

            if (allergens != null && allergens.length > 0) {
                // 例: "A01,A05" という文字列になる
                loginUser.setAllergenId(String.join(",", allergens));
            } else {
                // 何も選択されていない場合は空文字
                loginUser.setAllergenId("");
            }

            // DB更新実行
            boolean result = dao.updateUser(loginUser);

            if (result) {
                // セッション情報の更新
                session.setAttribute("user", loginUser);
                // 完了画面へ
                req.getRequestDispatcher("profile-complete.jsp").forward(req, res);
            } else {
                req.setAttribute("errorMessage", "DBの更新に失敗しました。");
                reloadEditData(req, loginUser);
                req.getRequestDispatcher("user-profile.jsp").forward(req, res);
            }
        }
    }

    /**
     * 編集画面の再表示に必要なデータをセットする共通メソッド
     */
    private void reloadEditData(HttpServletRequest req, Users user) throws Exception {
        AllergenDAO allergenDao = new AllergenDAO();
        List<Allergen> allergenList = allergenDao.getAllAllergens();
        req.setAttribute("allergenList", allergenList);
        req.setAttribute("user", user);
    }
}