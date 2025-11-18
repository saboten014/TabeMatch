package tabematch.main;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import tool.Action;

public class ReviewPostFormAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res)
            throws Exception {

        String shopId = req.getParameter("shopId");

        req.setAttribute("shopId", shopId);

        req.getRequestDispatcher("review_post_form.jsp").forward(req, res);
    }
}
