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

            // ★ 重要：更新前のIDを保持（WHERE句で使うため）
            String oldUserId = loginUser.getUserId();

            // Beanの更新
            loginUser.setUserName(userName);
            loginUser.setPassword(password);
            loginUser.setUserId(userMail);

            // アレルギー設定
            if (allergens != null && allergens.length > 0) {
                loginUser.setAllergenId(String.join(",", allergens));
            } else {
                loginUser.setAllergenId("");
            }

            try {
                // ★ 修正：古いIDを引数として渡す
                boolean result = dao.updateUser(loginUser, oldUserId);

                if (result) {
                    session.setAttribute("user", loginUser);
                    req.getRequestDispatcher("profile-complete.jsp").forward(req, res);
                } else {
                    req.setAttribute("errorMessage", "DBの更新に失敗しました。（更新対象が見つからないか、制約違反です）");
                    reloadEditData(req, loginUser);
                    req.getRequestDispatcher("user-profile.jsp").forward(req, res);
                }

            } catch (Exception e) {
                // エラーの詳細をコンソールに出力
                e.printStackTrace();

                // 失敗したのでBeanを元のIDに戻す（画面表示の整合性のため）
                loginUser.setUserId(oldUserId);

                // 画面に具体的なエラー原因を表示
                req.setAttribute("errorMessage", "エラー発生: " + e.getMessage());
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