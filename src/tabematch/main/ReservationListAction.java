package tabematch.main;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Reserve;
import bean.Users;
import dao.ReserveDAO;
import tool.Action;

public class ReservationListAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
        HttpSession session = req.getSession(false);
        Users loginUser = session != null ? (Users) session.getAttribute("user") : null;
        if (loginUser == null) {
            res.sendRedirect(req.getContextPath() + "/tabematch/login.jsp");
            return;
        }

        ReserveDAO reserveDao = new ReserveDAO();
        List<Reserve> reservations = reserveDao.findByUser(loginUser.getUserId());
        req.setAttribute("reservations", reservations);
        req.getRequestDispatcher("reservation-list.jsp").forward(req, res);
    }
}