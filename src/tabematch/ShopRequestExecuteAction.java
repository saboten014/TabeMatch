package tabematch;

import java.io.File;
import java.io.InputStream;
import java.util.Collection;
import java.util.List;
import java.util.Scanner;
import java.util.StringJoiner;
import java.util.UUID;

import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import bean.Allergen;
import bean.Request;
import dao.AllergenDAO;
import dao.RequestDAO;
import tool.Action;
import util.PasswordGenerator;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,
    maxFileSize = 1024 * 1024 * 5,
    maxRequestSize = 1024 * 1024 * 10
)
public class ShopRequestExecuteAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        String url = "";
        RequestDAO requestDao = new RequestDAO();

        // --- 1. フォーム値の取得（一度だけ取得して変数に格納） ---
        String address        = getFormField(req, "address");
        String restaurantName = getFormField(req, "restaurantName");
        String reservationStr = getFormField(req, "reservation");
        String businessHours  = getFormField(req, "businessHours");
        String payment        = getFormField(req, "payment");
        String genre          = getFormField(req, "genre");
        String priceRange     = getFormField(req, "priceRange");
        String seat           = getFormField(req, "seat");
        String link           = getFormField(req, "link");
        String number         = getFormField(req, "number");
        String request_mail   = getFormField(req, "request_mail");

        // --- 2. アレルギーIDを「名前」に変換する処理 ---
        String[] allergyArray = req.getParameterValues("allergyInfo");
        String allergySupportName = "";

        if (allergyArray != null && allergyArray.length > 0) {
            AllergenDAO allergenDao = new AllergenDAO();
            List<Allergen> masterList = allergenDao.getAllAllergens();
            StringJoiner nameJoiner = new StringJoiner(",");

            for (String selectedId : allergyArray) {
                for (Allergen master : masterList) {
                    if (master.getAllergenId().equals(selectedId)) {
                        nameJoiner.add(master.getAllergenName());
                        break;
                    }
                }
            }
            allergySupportName = nameJoiner.toString();
        }

        // --- 3. 画像ファイル処理 ---
        StringJoiner fileNames = new StringJoiner(",");
        String savePath = req.getServletContext().getRealPath("/upload");
        File uploadDir = new File(savePath);
        if (!uploadDir.exists()) { uploadDir.mkdir(); }

        Collection<Part> parts = req.getParts();
        for (Part part : parts) {
            if (part.getName().equals("photo") && part.getSize() > 0) {
                String originalFileName = part.getSubmittedFileName();
                String uniqueFileName = UUID.randomUUID().toString() + "_" + originalFileName;
                part.write(savePath + File.separator + uniqueFileName);
                fileNames.add(uniqueFileName);
            }
        }
        String finalFileName = fileNames.toString();

        // --- 4. 入力チェック（取得済みの変数を使用） ---

        String emailPattern = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$";


        if (isEmpty(address) || isEmpty(restaurantName) || allergySupportName.isEmpty() ||
            isEmpty(reservationStr) || isEmpty(businessHours) || isEmpty(payment) ||
            isEmpty(genre) || isEmpty(seat) || isEmpty(number) || isEmpty(request_mail)) {

            req.setAttribute("errorMessage", "必須項目をすべて入力してください。");
            url = "shop-request.jsp";

        }else if (!request_mail.matches(emailPattern)) { // メールのチェック

            req.setAttribute("errorMessage", "無効なメールアドレス形式です。");
            url = "shop-request.jsp";

        } else {
            Request request = new Request();
            request.setRequestId(PasswordGenerator.generateRequestId());
            request.setAddress(address);
            request.setRestaurantName(restaurantName);
            // ★IDではなく「変換後の名前」をセット！
            request.setAllergySupport(allergySupportName);
            request.setReservation(Integer.parseInt(reservationStr));
            request.setBusinessHours(businessHours);
            request.setPayment(payment);
            request.setGenre(genre);
            request.setPhoto(finalFileName);
            request.setPriceRange(priceRange);
            request.setSeat(seat);
            request.setLink(link);

            request.setNumber(number);

            request.setCertification(1);
            request.setRequest_mail(request_mail);

            boolean result = requestDao.insertRequest(request);

            if (result) {
                req.setAttribute("requestId", request.getRequestId());
                url = "shop-request-complete.jsp";
            } else {
                req.setAttribute("errorMessage", "リクエストの送信に失敗しました。");
                url = "shop-request.jsp";
            }
        }

        req.getRequestDispatcher(url).forward(req, res);
    }

    // ★ストリームの読み込みを安定させた修正版メソッド
    private String getFormField(HttpServletRequest req, String name) throws Exception {
        Part part = req.getPart(name);
        if (part == null || part.getSize() == 0) return null;

        try (InputStream is = part.getInputStream();
             Scanner s = new Scanner(is, "UTF-8")) {
            s.useDelimiter("\\A");
            return s.hasNext() ? s.next().trim() : null;
        }
    }

    private boolean isEmpty(String s) {
        if (s == null) return true;
        return s.replace("　", "").trim().isEmpty();
    }
}