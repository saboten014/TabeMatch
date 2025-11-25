package tabematch.admin;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Users;
import dao.UserDAO;
import tool.Action;

public class AdminUserListAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        UserDAO dao = new UserDAO();

        // ★フィルタ文字（ア・カ・A など）
        String kana = req.getParameter("kana");
        if (kana != null && kana.equals("ALL")) {
            kana = null; // ALL の場合はフィルタ解除
        }

        // ★ページ番号（デフォルト1）
        int page = 1;
        if (req.getParameter("page") != null) {
            try {
                page = Integer.parseInt(req.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int limit = 20;
        int offset = (page - 1) * limit;

        // ★総件数（フィルタ適用）
        int total = dao.getGeneralUserCount(kana);

        // ★最大ページ数
        int maxPage = (int)Math.ceil((double)total / limit);

        // ★一覧取得
        List<Users> list = dao.getGeneralUserList(kana, offset, limit);

        // JSP へ渡す
        req.setAttribute("userList", list);
        req.setAttribute("page", page);
        req.setAttribute("maxPage", maxPage);
        req.setAttribute("kana", kana);

        req.getRequestDispatcher("/tabematch/admin/admin-user-list.jsp").forward(req, res);
    }
}
