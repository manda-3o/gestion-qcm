package com.gestionqcm.servlet;

import com.gestionqcm.dao.ExamenDAO;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

/** Contrôleur du classement par mérite et statistiques. */
public class ClassementServlet extends HttpServlet {

    private final ExamenDAO examenDAO = new ExamenDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("classement",    examenDAO.getClassement());
            req.setAttribute("moyGenerale",   String.format("%.1f", examenDAO.getMoyenneGenerale()));
            req.setAttribute("nbPassed",      examenDAO.countPassed());
            req.setAttribute("nbExamens",     examenDAO.countAll());
            req.setAttribute("bestNote",      examenDAO.getBestNote());

        } catch (Exception e) {
            req.setAttribute("erreur", "Erreur : " + e.getMessage());
        }
        req.getRequestDispatcher("/views/classement/list.jsp").forward(req, resp);
    }
}
