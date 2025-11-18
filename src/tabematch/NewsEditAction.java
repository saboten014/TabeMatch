package tabematch;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.News;
import bean.Users; // 管理者チェック用
import dao.NewsDAO;
import tool.Action;

public class NewsEditAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res)
            throws Exception {

        HttpSession session = req.getSession();
        // 1. 管理者権限チェック
        Users user = (Users)session.getAttribute("user");
        if (user == null || !"3".equals(user.getUsersTypeId())) {
            req.setAttribute("errorMessage", "管理者権限が必要です。");
            req.getRequestDispatcher("/login.jsp").forward(req, res);
            return;
        }

        // 2. 編集対象のIDを取得
        String newsIdStr = req.getParameter("news_id");
        if (newsIdStr == null || newsIdStr.isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/News.action"); // IDがない場合は一覧へ戻す
            return;
        }

        // 3. IDをint型に変換し、DAOでデータを取得
        NewsDAO dao = new NewsDAO();
        int newsId = Integer.parseInt(newsIdStr);
        News news = dao.findById(newsId); // ★DAOメソッドはIDをintで受け取るよう修正が必要です

        if (news == null) {
            session.setAttribute("message", "編集対象のお知らせが見つかりませんでした。");
            res.sendRedirect(req.getContextPath() + "/News.action");
            return;
        }

        // 4. データをフォームに渡す
        req.setAttribute("news", news);
        req.getRequestDispatcher("main/news-edit.jsp").forward(req, res);
    }
}