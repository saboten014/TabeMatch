package tabematch.admin;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Users;
import dao.UserDAO;
import tool.Action;

public class AdminAdminListAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        UserDAO dao = new UserDAO();

        // フィルタ（先頭文字）
        String kana = req.getParameter("kana");
        if (kana != null && kana.equals("ALL")) {
            kana = null;
        }

        // ページ番号（デフォルト1）
        int pageNum = 1;
        if (req.getParameter("page") != null) {
            try {
                pageNum = Integer.parseInt(req.getParameter("page"));
            } catch (NumberFormatException e) {
                pageNum = 1;
            }
        }

        int limit = 20;
        int offset = (pageNum - 1) * limit;

        // ★フィルタ付き件数カウント
        int total = dao.getAdminCount(kana);

        // 最大ページ数
        int maxPage = (int) Math.ceil((double) total / limit);

        // ★フィルタ + ページネーション付き管理者リスト
        List<Users> list = dao.getAdminList(kana, offset, limit);

        // JSPに渡す値
        req.setAttribute("adminList", list);
        req.setAttribute("pageNum", pageNum);
        req.setAttribute("maxPage", maxPage);
        req.setAttribute("kana", kana);

        req.getRequestDispatcher("/tabematch/admin/admin-admin-list.jsp").forward(req, res);
    }
}
