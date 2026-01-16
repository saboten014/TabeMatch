package tabematch.main;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Allergen; // 追加
import bean.Users;
import dao.AllergenDAO;
import dao.UserDAO;
import tool.Action;

public class UserProfileViewAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res)
            throws Exception {

        HttpSession session = req.getSession();
        Users loginUser = (Users) session.getAttribute("user");

        // 未ログイン対策
        if (loginUser == null) {
            req.setAttribute("errorMessage", "ログインが必要です。");
            req.getRequestDispatcher("../login.jsp").forward(req, res);
            return;
        }

        // 店舗ユーザーは別画面へ誘導
        if ("2".equals(loginUser.getUsersTypeId())) {
            res.sendRedirect("ShopProfileView.action");
            return;
        }

        // DBからユーザー最新情報を再取得
        UserDAO dao = new UserDAO();
        Users user = dao.getUserById(loginUser.getUserId());

        if (user == null) {
            req.setAttribute("errorMessage", "ユーザー情報が取得できません。");
            req.getRequestDispatcher("../error.jsp").forward(req, res);
            return;
        }

        // --- ★アレルギー情報の取得処理 ---
        AllergenDAO aldao = new AllergenDAO();
        List<Allergen> allergenList = aldao.getAllergensByUserId(user.getUserId());


     // JSP側で表示するためにリクエストにセット
        req.setAttribute("allergenList", allergenList);
        // --- ★ここまで ---
        req.setAttribute("user", user);
        req.getRequestDispatcher("user-profile-view.jsp").forward(req, res);
    }
}