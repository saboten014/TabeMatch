package tabematch;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Users;
import dao.UserDAO;
import tool.Action;

public class UserPassUpdateAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res)
            throws Exception {

        HttpSession session = req.getSession();
        Users user = (Users) session.getAttribute("user");

        // 遷移先URLの初期設定（変更フォームに戻す）
        String url = "/tabematch/main/password-change.jsp";

        // 1. ログインチェック
        if (user == null) {
            // ログインしていない場合はログイン画面へリダイレクト
            res.sendRedirect(req.getContextPath() + "/tabematch/login.jsp");
            return;
        }

        // セッションからユーザーID（メールアドレス）を取得
        String userId = user.getUserId();

        // 2. フォームから入力値を取得
        String currentPassword = req.getParameter("currentPassword");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        // 3. バリデーションチェック
        if (currentPassword == null || currentPassword.isEmpty() ||
            newPassword == null || newPassword.isEmpty() ||
            confirmPassword == null || confirmPassword.isEmpty()) {

            req.setAttribute("errorMessage", "すべての項目を入力してください。");
            req.getRequestDispatcher(url).forward(req, res);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            req.setAttribute("errorMessage", "新しいパスワードと確認用パスワードが一致しません。");
            req.getRequestDispatcher(url).forward(req, res);
            return;
        }

        // 4. 現在のパスワードで認証（本人確認）
        UserDAO usersDAO = new UserDAO();

        // DAOのsearchメソッドで、ユーザーIDと現在のパスワードが一致するか確認する
        // ※ searchメソッドが、メールアドレス(user_id)とパスワードの組み合わせで
        //    ユーザーを検索・認証する機能を持つことを前提とします。
        Users authenticatedUser = usersDAO.login(userId, currentPassword);

        if (authenticatedUser == null) {
            // 認証失敗
            req.setAttribute("errorMessage", "パスワードが間違っています。");
            req.getRequestDispatcher(url).forward(req, res);
            return;
        }

        // 5. パスワードの更新処理

        // ★★★ 注意: データベースに保存する前に、新しいパスワードをハッシュ化すること！ ★★★
        // ここでは簡単な文字列として扱いますが、実運用ではセキュリティを確保してください。
        String newHashedPassword = newPassword; // <--- 実際はここでハッシュ化処理を実行

        int rows = usersDAO.updatePassword(userId, newHashedPassword);

        if (rows > 0) {
            // 更新成功
            // セッション情報を更新（ユーザーオブジェクトにパスワードハッシュが含まれる場合）
            // 通常、セッションのuserオブジェクトにはパスワードを保持しないため、この行は省略可
            // user.setPassword(newHashedPassword);

            req.setAttribute("successMessage", "パスワードを変更しました。");
            url = "/tabematch/main/password-change-complete.jsp"; // 完了画面へ
        } else {
            // 更新失敗 (DBエラーなど)
            req.setAttribute("errorMessage", "パスワードの更新に失敗しました。時間をおいて再度お試しください。");
            url = "/main/password-change.jsp"; // フォームに戻す
        }

        req.getRequestDispatcher(url).forward(req, res);
    }
}