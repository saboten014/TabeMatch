package tabematch;

import java.io.File;
import java.io.InputStream;
import java.util.Collection; // 追加
import java.util.Scanner;
import java.util.StringJoiner; // 追加
import java.util.UUID;

import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import bean.Request;
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
    public void execute(HttpServletRequest req, HttpServletResponse res)
            throws Exception {

        String url = "";
        RequestDAO requestDao = new RequestDAO();

        // --- フォーム値取得 ---
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

        String[] allergyArray = req.getParameterValues("allergyInfo");
        String allergySupport = (allergyArray != null) ? String.join(",", allergyArray) : "";

        // --- ★画像ファイル処理（複数対応版） ---
        StringJoiner fileNames = new StringJoiner(",");
        String savePath = req.getServletContext().getRealPath("/upload");
        File uploadDir = new File(savePath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }

        // 全てのPartを取得してループを回す
        Collection<Part> parts = req.getParts();
        for (Part part : parts) {
            // inputのname属性が "photo" で、かつファイルが存在する場合
            if (part.getName().equals("photo") && part.getSize() > 0) {
                String originalFileName = part.getSubmittedFileName();
                String uniqueFileName = UUID.randomUUID().toString() + "_" + originalFileName;

                // サーバーに保存
                part.write(savePath + File.separator + uniqueFileName);

                // ファイル名をStringJoinerに追加
                fileNames.add(uniqueFileName);
            }
        }

        // 最終的なカンマ区切りの文字列（例: "uuid1.jpg,uuid2.png"）
        String finalFileName = fileNames.toString();

        // --- 入力チェック ---
        if (isEmpty(address) ||
            isEmpty(restaurantName) ||
            allergySupport.isEmpty() ||
            isEmpty(reservationStr) ||
            isEmpty(businessHours) ||
            isEmpty(payment) ||
            isEmpty(genre) ||
            isEmpty(seat) ||
            isEmpty(number) ||
            isEmpty(request_mail)) {

            req.setAttribute("errorMessage", "必須項目をすべて入力してください。");
            url = "shop-request.jsp";
        }
        else {
            Request request = new Request();
            request.setRequestId(PasswordGenerator.generateRequestId());
            request.setAddress(address);
            request.setRestaurantName(restaurantName);
            request.setAllergySupport(allergySupport);
            request.setReservation(Integer.parseInt(reservationStr));
            request.setBusinessHours(businessHours);
            request.setPayment(payment);
            request.setGenre(genre);

            // ★ここにカンマ区切りの文字列をセット
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

    private String getFormField(HttpServletRequest req, String name) throws Exception {
        Part part = req.getPart(name);
        if (part == null) return null;

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