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

        // ログインチェック
        if (loginUser == null) {
            req.setAttribute("errorMessage", "ログインが必要です。");
            req.getRequestDispatcher("../../error.jsp").forward(req, res);
            return;
        }

        // パラメータ取得
        String shopId = req.getParameter("shopId");
        String title = req.getParameter("title");
        String body = req.getParameter("body");
        String ratingParam = req.getParameter("rating");

        // バリデーション
        if (shopId == null || shopId.trim().isEmpty()) {
            session.setAttribute("errorMessage", "店舗IDが取得できませんでした。");
            res.sendRedirect("Search.action");
            return;
        }

        if (title == null || title.trim().isEmpty() ||
            body == null || body.trim().isEmpty() ||
            ratingParam == null || ratingParam.trim().isEmpty()) {
            session.setAttribute("errorMessage", "すべての項目を入力してください。");
            res.sendRedirect("ReviewPostForm.action?shopId=" + shopId);
            return;
        }

        int rating;
        try {
            rating = Integer.parseInt(ratingParam);
            if (rating < 1 || rating > 5) {
                throw new NumberFormatException();
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "評価は1〜5の範囲で選択してください。");
            res.sendRedirect("ReviewPostForm.action?shopId=" + shopId);
            return;
        }

        // Reviewオブジェクト作成
        Review review = new Review();
        review.setReviewIdString("REV" + System.currentTimeMillis());
        review.setUserIdString(loginUser.getUserId());
        review.setShopIdString(shopId);
        review.setTitle(title);
        review.setBody(body);
        review.setRating(rating);
        review.setCreatedAt(LocalDateTime.now());

        // DB登録
        ReviewDAO dao = new ReviewDAO();
        boolean result = dao.insertReview(review);

        if (result) {
            session.setAttribute("successMessage", "口コミを投稿しました。");
            // ★修正: 投稿後は口コミ一覧にリダイレクト
            res.sendRedirect("ReviewList.action?shopId=" + shopId);
        } else {
            session.setAttribute("errorMessage", "投稿に失敗しました。もう一度お試しください。");
            res.sendRedirect("ReviewPostForm.action?shopId=" + shopId);
        }
    }
}