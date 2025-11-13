package tabematch;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.News;
import dao.NewsDAO;
import tool.Action;

public class NewsPostFormAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res)
            throws Exception {

        // 1. セッションから管理者権限を確認 (セキュリティチェック)
        HttpSession session = req.getSession();
        Boolean isAdmin = (Boolean)session.getAttribute("admin");

        // 管理者でない場合はアクセスを拒否し、エラーまたはトップへリダイレクト
        if (isAdmin == null || !isAdmin) {
            res.sendRedirect(req.getContextPath() + "/top.jsp");
            return;
        }

        // 2. リクエストパラメータの取得
        // フォームからの送信があったかどうかは、タイトル（必須項目）の有無で判定
        String newsTitle = req.getParameter("newsTitle");
        String newsText = req.getParameter("newsText");

        if (newsTitle != null && !newsTitle.isEmpty() && newsText != null) {

            // =========== (A) データが揃っている場合：DBに登録する ===========

            // 3. データ処理とDAOの実行
            try {
                NewsDAO newsDao = new NewsDAO();
                News news = new News();

                // 登録するNewsオブジェクトに値をセット
                // IDはDB側で自動採番されると仮定
                news.setNewsTitle(newsTitle);
                news.setNewsText(newsText);

                // 登録日時（DeliveryDate）はDAO側でCURRENT_TIMESTAMPを設定すると仮定

                boolean success = newsDao.insert(news); // ★DAOにこのメソッドを追加する必要があります

                if (success) {
                    session.setAttribute("message", "新しいお知らせの投稿が完了しました。");
                } else {
                    session.setAttribute("message", "お知らせの投稿に失敗しました。データベースエラー。");
                }

                // 4. 登録後、お知らせ一覧画面にリダイレクト
                res.sendRedirect(req.getContextPath() + "/tabematch/News.action");

            } catch (Exception e) {
                // データベース処理で例外が発生した場合
                e.printStackTrace();
                session.setAttribute("message", "お知らせの登録中に予期せぬエラーが発生しました。");
                res.sendRedirect(req.getContextPath() + "/tabematch/News.action");
            }

        } else {

            // =========== (B) データがない、または不足している場合：フォーム画面に遷移する ===========

            // 3. フォーム画面のJSPにフォワード
            // JSPのパスは適切に調整してください (例: /tabematch/admin/news_post_form.jsp など)
            req.getRequestDispatcher("/tabematch/main/news_post_form.jsp").forward(req, res);
        }
    }
}