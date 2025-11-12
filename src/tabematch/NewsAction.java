package tabematch;

import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.News;
import bean.Users;
import dao.NewsDAO;
import tool.Action;


public class NewsAction extends Action{

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res)
			throws Exception {

		// 1. ローカル変数の設定
		HttpSession session = req.getSession();
		NewsDAO newsDao = new NewsDAO();

		// 2. お知らせリストの取得
		List<News> list = newsDao.all();

		// 3. ログインユーザーの取得と管理者ステータスの判定
		Users user = (Users)session.getAttribute("user");

		// ユーザーが存在し、かつUsersTypeIdが"3"であればtrue
		boolean isAdmin = (user != null && "3".equals(user.getUsersTypeId()));

		// 4. セッションへの設定
		session.setAttribute("list", list);
		// 管理者ステータスをセッションに設定
		session.setAttribute("admin", isAdmin);

		// 5. 遷移先URLの返却
		RequestDispatcher dispatcher = req.getRequestDispatcher("news_list.jsp");
		dispatcher.forward(req, res);
	}
}