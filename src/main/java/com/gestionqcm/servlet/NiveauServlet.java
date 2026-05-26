package com.gestionqcm.servlet;

import com.gestionqcm.dao.EtudiantDAO;
import com.gestionqcm.dao.ExamenDAO;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

/** Contrôleur : liste par niveau avec effectif. */
public class NiveauServlet extends HttpServlet {

    private final EtudiantDAO etudiantDAO = new EtudiantDAO();
    private final ExamenDAO   examenDAO   = new ExamenDAO();
    private static final String[] NIVEAUX = {"L1","L2","L3","M1","M2"};

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String niveau = req.getParameter("niveau");
        if (niveau == null || niveau.isEmpty()) niveau = "L1";

        try {
            req.setAttribute("niveau",      niveau);
            req.setAttribute("niveaux",     NIVEAUX);
            req.setAttribute("etudiants",   etudiantDAO.findByNiveau(niveau));
            req.setAttribute("effectif",    etudiantDAO.countByNiveau(niveau));
            req.setAttribute("examens",     examenDAO.findAll());

        } catch (Exception e) {
            req.setAttribute("erreur", "Erreur : " + e.getMessage());
        }

        req.getRequestDispatcher("/views/etudiant/niveaux.jsp").forward(req, resp);
    }
}
