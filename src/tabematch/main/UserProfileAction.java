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

        // ログインチェック
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

        if (mode == null) {
            req.setAttribute("user", loginUser);
            AllergenDAO allergenDao = new AllergenDAO();
            List<Allergen> allergenList = allergenDao.getAllAllergens();
            req.setAttribute("allergenList", allergenList);
            req.getRequestDispatcher("user-profile.jsp").forward(req, res);
        	} else if (mode.equals("update")) {
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
                req.setAttribute("user", loginUser);
                req.getRequestDispatcher("user-profile.jsp").forward(req, res);
                return;
            }

            if (!password.equals(confirmPassword)) {
                req.setAttribute("errorMessage", "パスワードが一致しません。");
                req.setAttribute("user", loginUser);
                req.getRequestDispatcher("user-profile.jsp").forward(req, res);
                return;
            }

            // Bean更新
            loginUser.setUserName(userName);
            loginUser.setPassword(password);
            loginUser.setUserId(userMail);
            if (allergens != null) {
                loginUser.setAllergenId(String.join(",", allergens));
            } else {
                loginUser.setAllergenId("");
            }

            // DB更新
            boolean result = dao.updateUser(loginUser);

            if (result) {
                session.setAttribute("user", loginUser);
                req.setAttribute("successMessage", "プロフィールを更新しました。");
                req.getRequestDispatcher("profile-complete.jsp").forward(req, res);
            } else {
                req.setAttribute("errorMessage", "更新に失敗しました。");
                req.getRequestDispatcher("user-profile.jsp").forward(req, res);
            }
        }
    }
}
