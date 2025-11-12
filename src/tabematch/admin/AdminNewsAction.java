package tabematch.admin;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.NewsDAO;
import tool.Action;

//お知らせ配信用のアクション
//管理者用だから、書き込みができるようにしないとね
//最初に管理者アカウントでログインしているかを確認して、管理者アカウント⇒そのまま処理へ

//一般、もしくは店舗用アカウントであれば、NewsActionへ遷移させようかな
//思ったけどこれ一個のActionで済むくね？？どうしようかな

public class AdminNewsAction extends Action{

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res)
			throws Exception {

		//ローカル変数
		HttpSession session = req.getSession();
		String url = "";
		NewsDAO newsDao = new NewsDAO();

		// リクエストパラメータの取得
		String newsTitle = req.getParameter("newsTitle");
		String newsText = req.getParameter("newsText");

		//入力しているのか確認
		if (newsTitle != null || newsText != null){
			//DB登録処理
			//IDを自動でつけるのと、日にちを持ってくる
		}

		//入力が足りていなければ
		req.setAttribute("errorMessage", "入力していない項目があります");
		url = "deliverMessage.jsp"; //お知らせ本文入力フォーム用jsp

	}

}
