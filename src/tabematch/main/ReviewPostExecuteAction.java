package tabematch.main;

import java.time.LocalDateTime;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Review;
import bean.Users;
import dao.ReviewDAO;
import tool.Action;

public class ReviewPostExecuteAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        HttpSession session = req.getSession();
        Users loginUser = (Users) session.getAttribute("user");

        if (loginUser == null) {
            req.setAttribute("errorMessage", "ログインが必要です。");
            req.getRequestDispatcher("../../error.jsp").forward(req, res);
            return;
        }

        String shopId = req.getParameter("shopId");
        String title = req.getParameter("title");
        String body = req.getParameter("body");
        int rating = Integer.parseInt(req.getParameter("rating"));

        Review review = new Review();
        review.setReviewIdString("REV" + System.currentTimeMillis());
        review.setUserIdString(loginUser.getUserId());
        review.setShopIdString(shopId);
        review.setTitle(title);
        review.setBody(body);
        review.setRating(rating);
        review.setCreatedAt(LocalDateTime.now());

        ReviewDAO dao = new ReviewDAO();
        boolean result = dao.insertReview(review);

        if (result) {
            req.setAttribute("successMessage", "口コミを投稿しました。");
        } else {
            req.setAttribute("errorMessage", "投稿に失敗しました。");
        }

        req.getRequestDispatcher("review_post_complete.jsp").forward(req, res);
    }
}
