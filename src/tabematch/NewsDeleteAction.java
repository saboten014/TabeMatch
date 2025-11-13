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

        HttpSession session = req.getSession();
        Boolean isAdmin = (Boolean)session.getAttribute("admin");

        // 1. セキュリティチェック
        if (isAdmin == null || !isAdmin) {
            res.sendRedirect(req.getContextPath() + "/Error.action");
            return;
        }

        // 2. リクエストパラメータ（newsId）の取得と型変換
        String newsIdStr = req.getParameter("newsId"); // Stringとして取得
        int newsId = 0; // 削除対象のIDを保持

        // IDがないか、数値として不正な場合は一覧へ戻す
        if (newsIdStr == null || newsIdStr.isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/tabematch/NewsAction.action");
            return;
        }

        try {
            // ★Stringからintへの変換
            newsId = Integer.parseInt(newsIdStr);
        } catch (NumberFormatException e) {
            // 数値に変換できなかった場合もエラーとして一覧へ戻す
            session.setAttribute("message", "不正なIDが指定されました。");
            res.sendRedirect(req.getContextPath() + "/tabematch/NewsAction.action");
            return;
        }


        // 3. DAOを使ってデータを削除
        NewsDAO newsDao = new NewsDAO();
        // ★DAOのdeleteメソッドにはint型のIDを渡す
        boolean success = newsDao.delete(newsId);

        // 4. 処理結果に基づいてリダイレクト
        if (success) {
            session.setAttribute("message", "お知らせの削除が完了しました。");
        } else {
            session.setAttribute("message", "お知らせの削除に失敗しました。（ID: " + newsId + "）");
        }

        // リダイレクト先を /tabematch/NewsAction.action に修正
        res.sendRedirect(req.getContextPath() + "/tabematch/News.action");
    }
}