package tabematch;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Users;
import dao.UserDAO;
import tool.Action;

public class UserPassUpdateAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        HttpSession session = req.getSession();
        Users user = (Users) session.getAttribute("user");
        String url = "/tabematch/main/password-change.jsp"; // 入力画面

        // 1. ログインチェック
        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/tabematch/login.jsp");
            return;
        }

        String currentUserId = user.getUserId();

        // 2. フォーム値の取得
        String currentPassword = req.getParameter("currentPassword");
        String newEmail = req.getParameter("newEmail");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        // 3. 基本バリデーション
        if (currentPassword == null || currentPassword.isEmpty()) {
            req.setAttribute("errorMessage", "本人確認のため現在のパスワードを入力してください。");
            req.getRequestDispatcher(url).forward(req, res);
            return;
        }

        UserDAO usersDAO = new UserDAO();

        // 4. 現在のパスワードで本人確認
        Users authenticatedUser = usersDAO.login(currentUserId, currentPassword);
        if (authenticatedUser == null) {
            req.setAttribute("errorMessage", "現在のパスワードが間違っています。");
            req.getRequestDispatcher(url).forward(req, res);
            return;
        }

        // 5. 更新内容の判定
        boolean isEmailChanged = (newEmail != null && !newEmail.isEmpty() && !newEmail.equals(currentUserId));
        boolean isPasswordChanged = (newPassword != null && !newPassword.isEmpty());

        if (!isEmailChanged && !isPasswordChanged) {
            req.setAttribute("errorMessage", "変更内容を入力してください。");
            req.getRequestDispatcher(url).forward(req, res);
            return;
        }

        // メールアドレス重複チェック
        if (isEmailChanged) {
            if (usersDAO.isEmailExists(newEmail)) {
                req.setAttribute("errorMessage", "入力されたメールアドレスは既に登録されています。");
                req.setAttribute("newEmail", newEmail); // 入力値を保持
                req.getRequestDispatcher(url).forward(req, res);
                return;
            }
        }

        // パスワード一致チェック
        if (isPasswordChanged) {
            if (!newPassword.equals(confirmPassword)) {
                req.setAttribute("errorMessage", "新しいパスワードと確認用が一致しません。");
                req.setAttribute("newEmail", newEmail);
                req.getRequestDispatcher(url).forward(req, res);
                return;
            }
        }

        // 6. DB更新実行
        String mailToSave = isEmailChanged ? newEmail : currentUserId;
        String passToSave = isPasswordChanged ? newPassword : currentPassword;

        int result = usersDAO.updateUserInfo(currentUserId, mailToSave, passToSave);

        if (result > 0) {
            // ✅ セッションを無効化（ログアウト）
            session.invalidate();

            req.setAttribute("successMessage", "情報を更新しました✨");
            url = "/tabematch/main/password-change-complete.jsp";
        } else {
            req.setAttribute("errorMessage", "更新に失敗しました。");
        }

        req.getRequestDispatcher(url).forward(req, res);
    }
}