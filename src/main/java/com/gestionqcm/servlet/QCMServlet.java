package com.gestionqcm.servlet;

import com.gestionqcm.dao.QCMDAO;
import com.gestionqcm.model.QCM;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/** Contrôleur CRUD des questions QCM. */
public class QCMServlet extends HttpServlet {

    private final QCMDAO dao = new QCMDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        String search = req.getParameter("search");

        try {
            List<QCM> liste = (search != null && !search.trim().isEmpty())
                    ? dao.search(search.trim())
                    : dao.findAll();

            req.setAttribute("qcmList", liste);
            req.setAttribute("search",  search);

            if ("edit".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("editQcm", dao.findById(id));
            }

        } catch (Exception e) {
            req.setAttribute("erreur", "Erreur : " + e.getMessage());
        }

        req.getRequestDispatcher("/views/qcm/list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        try {
            if ("insert".equals(action)) {
                dao.insert(buildFromRequest(req));
                req.setAttribute("succes", "Question ajoutée avec succès.");

            } else if ("update".equals(action)) {
                dao.update(buildFromRequest(req));
                req.setAttribute("succes", "Question modifiée avec succès.");

            } else if ("delete".equals(action)) {
                dao.delete(Integer.parseInt(req.getParameter("num_quest")));
                req.setAttribute("succes", "Question supprimée.");
            }

        } catch (Exception e) {
            req.setAttribute("erreur", "Erreur : " + e.getMessage());
        }

        doGet(req, resp);
    }

    private QCM buildFromRequest(HttpServletRequest req) {
        QCM q = new QCM();
        String idStr = req.getParameter("num_quest");
        if (idStr != null && !idStr.isEmpty()) q.setNumQuest(Integer.parseInt(idStr));
        q.setQuestion(req.getParameter("question"));
        q.setReponse1(req.getParameter("reponse1"));
        q.setReponse2(req.getParameter("reponse2"));
        q.setReponse3(req.getParameter("reponse3"));
        q.setReponse4(req.getParameter("reponse4"));
        q.setBonne(req.getParameter("bonne"));
        return q;
    }
}
