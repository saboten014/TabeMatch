package tabematch.main;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Review;
import dao.ReviewDAO;
import tool.Action;

public class ReviewListAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        String shopId = req.getParameter("shopId");

        ReviewDAO dao = new ReviewDAO();
        List<Review> list = dao.getReviewsByShopId(shopId);

        req.setAttribute("reviewList", list);

        req.getRequestDispatcher("review_list.jsp").forward(req, res);
    }
}
