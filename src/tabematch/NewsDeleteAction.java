package tabematch;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.NewsDAO;
import tool.Action; // tool.Action を継承

public class NewsDeleteAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res)
            throws Exception {

        // 1. セッションから管理者権限を確認 (セキュリティチェック)
        HttpSession session = req.getSession();
        Boolean isAdmin = (Boolean)session.getAttribute("admin");

        // 管理者でない場合はアクセスを拒否し、エラーまたはトップへリダイレクト
        if (isAdmin == null || !isAdmin) {
            res.sendRedirect(req.getContextPath() + "/Error.action"); // 適切なエラーアクションにリダイレクト
            return;
        }

        // 2. リクエストパラメータ（newsId）の取得
        // news_list.jspのフォームで設定された name="newsId" を使用
        String newsId = req.getParameter("newsId");

        // IDがない場合は一覧へ戻す
        if (newsId == null || newsId.isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/NewsAction.action");
            return;
        }

        // 3. DAOを使ってデータを削除
        NewsDAO newsDao = new NewsDAO();

        // 削除結果を保持するフラグ
        boolean success = newsDao.delete(newsId);

        // 4. 処理結果に基づいてリダイレクト
        if (success) {
            // 成功メッセージをセッションに一時的に保持してからリダイレクトすることも可能
            session.setAttribute("message", "お知らせの削除が完了しました。");
        } else {
            session.setAttribute("message", "お知らせの削除に失敗しました。");
        }

        // 削除処理後、一覧画面にリダイレクト
        // リダイレクトすることで、削除後の再読み込みで再び削除処理が走るのを防ぎます
        res.sendRedirect(req.getContextPath() + "/NewsAction.action");
    }
}