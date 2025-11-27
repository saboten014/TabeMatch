package tabematch.admin;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import tool.Action;

public class AdminShopInsertFormAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        req.getRequestDispatcher("/tabematch/admin/admin-shop-insert-form.jsp").forward(req, res);
    }

}
