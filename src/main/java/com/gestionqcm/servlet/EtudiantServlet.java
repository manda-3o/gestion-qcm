package com.gestionqcm.servlet;

import com.gestionqcm.dao.EtudiantDAO;
import com.gestionqcm.model.Etudiant;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/** Contrôleur CRUD des étudiants. */
public class EtudiantServlet extends HttpServlet {

    private final EtudiantDAO dao = new EtudiantDAO();
    private static final String[] NIVEAUX = {"L1","L2","L3","M1","M2"};

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action  = req.getParameter("action");
        String search  = req.getParameter("search");
        String niveau  = req.getParameter("niveau");

        try {
            List<Etudiant> liste;

            if (search != null && !search.trim().isEmpty()) {
                liste = dao.search(search.trim());
                req.setAttribute("search", search.trim());
            } else if (niveau != null && !niveau.trim().isEmpty()) {
                liste = dao.findByNiveau(niveau.trim());
                req.setAttribute("filterNiveau", niveau.trim());
            } else {
                liste = dao.findAll();
            }

            req.setAttribute("etudiants", liste);
            req.setAttribute("niveaux",   NIVEAUX);

            // Formulaire modification
            if ("edit".equals(action)) {
                String id = req.getParameter("id");
                req.setAttribute("editEtudiant", dao.findById(id));
            }

        } catch (Exception e) {
            req.setAttribute("erreur", "Erreur : " + e.getMessage());
        }

        req.getRequestDispatcher("/views/etudiant/list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        try {
            if ("insert".equals(action)) {
                Etudiant e = buildFromRequest(req);
                if (dao.exists(e.getNumEtudiant())) {
                    req.setAttribute("erreur", "Ce numéro étudiant existe déjà.");
                } else {
                    dao.insert(e);
                    req.setAttribute("succes", "Étudiant ajouté avec succès.");
                }

            } else if ("update".equals(action)) {
                dao.update(buildFromRequest(req));
                req.setAttribute("succes", "Étudiant modifié avec succès.");

            } else if ("delete".equals(action)) {
                String id = req.getParameter("num_etudiant");
                dao.delete(id);
                req.setAttribute("succes", "Étudiant supprimé.");
            }

        } catch (Exception e) {
            req.setAttribute("erreur", "Erreur : " + e.getMessage());
        }

        // Rechargement de la liste après action
        doGet(req, resp);
    }

    private Etudiant buildFromRequest(HttpServletRequest req) {
        return new Etudiant(
            req.getParameter("num_etudiant"),
            req.getParameter("Nom"),
            req.getParameter("Prenoms"),
            req.getParameter("Niveau"),
            req.getParameter("adr_email")
        );
    }
}
