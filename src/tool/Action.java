

//目的は「共通の入り口でWebリクエストを一括処理」すること。
//コントローラーを1箇所にまとめることで、コードの重複を防ぎ、保守性を高める。
//
//どんなアクションが呼ばれても、**共通のロジック（例外処理、ログ出力など）**をフロントコントローラーに集約できる。
//
//新しいアクションを追加するたびに、個別のサーブレットを作らなくて済む。


package tool;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public abstract class Action {

	public abstract void execute(
			HttpServletRequest req, HttpServletResponse res
		) throws Exception;

}
