package com.gestionqcm.servlet;

import com.gestionqcm.dao.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

/** Contrôleur du tableau de bord. */
public class DashboardServlet extends HttpServlet {

    private final EtudiantDAO etudiantDAO = new EtudiantDAO();
    private final QCMDAO      qcmDAO      = new QCMDAO();
    private final ExamenDAO   examenDAO   = new ExamenDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            // Statistiques globales
            req.setAttribute("nbEtudiants",  etudiantDAO.countAll());
            req.setAttribute("nbQuestions",  qcmDAO.countAll());
            req.setAttribute("nbExamens",    examenDAO.countAll());
            req.setAttribute("moyGenerale",  String.format("%.1f", examenDAO.getMoyenneGenerale()));
            req.setAttribute("nbPassed",     examenDAO.countPassed());
            req.setAttribute("bestNote",     examenDAO.getBestNote());

            // Derniers résultats (5 derniers)
            req.setAttribute("derniersResultats", examenDAO.findAll().stream()
                    .limit(5).collect(java.util.stream.Collectors.toList()));

            // Effectif par niveau
            String[] niveaux = {"L1","L2","L3","M1","M2"};
            java.util.Map<String,Integer> effectifs = new java.util.LinkedHashMap<>();
            for (String n : niveaux) effectifs.put(n, etudiantDAO.countByNiveau(n));
            req.setAttribute("effectifs", effectifs);
            req.setAttribute("niveaux",   niveaux);

        } catch (Exception e) {
            req.setAttribute("erreur", "Erreur : " + e.getMessage());
        }
        req.getRequestDispatcher("/views/dashboard.jsp").forward(req, resp);
    }
}
