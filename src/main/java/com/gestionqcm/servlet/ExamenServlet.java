package com.gestionqcm.servlet;

import com.gestionqcm.dao.*;
import com.gestionqcm.model.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

/**
 * Contrôleur de l'examen QCM.
 * Gère : liste des notes, démarrage, déroulement question/question,
 * calcul de la note finale, enregistrement et simulation d'email.
 */
public class ExamenServlet extends HttpServlet {

    private final EtudiantDAO etudiantDAO = new EtudiantDAO();
    private final QCMDAO      qcmDAO      = new QCMDAO();
    private final ExamenDAO   examenDAO   = new ExamenDAO();

    // ─── GET : affichage selon l'étape ───────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        try {
            if ("start".equals(action)) {
                // Formulaire de démarrage
                req.setAttribute("etudiants", etudiantDAO.findAll());
                req.getRequestDispatcher("/views/examen/start.jsp").forward(req, resp);

            } else if ("run".equals(action)) {
                // Afficher la question courante
                afficherQuestion(req, resp);

            } else if ("result".equals(action)) {
                // Résumé final avant enregistrement
                req.getRequestDispatcher("/views/examen/result.jsp").forward(req, resp);

            } else if ("mail".equals(action)) {
                // Prévisualisation email
                req.getRequestDispatcher("/views/examen/mail.jsp").forward(req, resp);

            } else {
                // Liste des notes
                String annee = req.getParameter("annee");
                List<Examen> liste = (annee != null && !annee.isEmpty())
                        ? examenDAO.findByAnnee(annee)
                        : examenDAO.findAll();
                req.setAttribute("examens",     liste);
                req.setAttribute("annees",      examenDAO.getAnnees());
                req.setAttribute("filterAnnee", annee);
                req.getRequestDispatcher("/views/examen/list.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            req.setAttribute("erreur", "Erreur : " + e.getMessage());
            req.getRequestDispatcher("/views/examen/list.jsp").forward(req, resp);
        }
    }

    // ─── POST : traitement des actions ───────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        try {
            if ("begin".equals(action)) {
                // Initialiser la session d'examen
                beginExam(req, resp);

            } else if ("answer".equals(action)) {
                // Enregistrer la réponse et passer à la suivante
                processAnswer(req, resp);

            } else if ("save".equals(action)) {
                // Sauvegarder la note en base et préparer l'email
                saveResult(req, resp);
            }

        } catch (Exception e) {
            req.setAttribute("erreur", "Erreur : " + e.getMessage());
            req.getRequestDispatcher("/views/examen/list.jsp").forward(req, resp);
        }
    }

    // ─── Démarrage de l'examen ────────────────────────────
    @SuppressWarnings("unchecked")
    private void beginExam(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {

        String numEtudiant = req.getParameter("num_etudiant");
        String anneeUniv   = req.getParameter("annee_univ");

        Etudiant etudiant = etudiantDAO.findById(numEtudiant);
        if (etudiant == null) {
            req.setAttribute("erreur", "Étudiant introuvable.");
            req.setAttribute("etudiants", etudiantDAO.findAll());
            req.getRequestDispatcher("/views/examen/start.jsp").forward(req, resp);
            return;
        }

        List<QCM> questions = qcmDAO.findRandom(10);

        HttpSession session = req.getSession();
        session.setAttribute("exam_etudiant",  etudiant);
        session.setAttribute("exam_annee",     anneeUniv);
        session.setAttribute("exam_questions", questions);
        session.setAttribute("exam_current",   0);
        session.setAttribute("exam_score",     0);
        session.setAttribute("exam_answers",   new ArrayList<Map<String,String>>());

        resp.sendRedirect(req.getContextPath() + "/examens?action=run");
    }

    // ─── Afficher la question courante ────────────────────
    @SuppressWarnings("unchecked")
    private void afficherQuestion(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {

        HttpSession    session   = req.getSession();
        List<QCM>      questions = (List<QCM>) session.getAttribute("exam_questions");
        Integer        current   = (Integer)   session.getAttribute("exam_current");

        if (questions == null || current == null) {
            resp.sendRedirect(req.getContextPath() + "/examens?action=start");
            return;
        }

        if (current >= questions.size()) {
            resp.sendRedirect(req.getContextPath() + "/examens?action=result");
            return;
        }

        req.setAttribute("question",   questions.get(current));
        req.setAttribute("current",    current + 1);
        req.setAttribute("total",      questions.size());
        req.setAttribute("score",      session.getAttribute("exam_score"));
        req.setAttribute("etudiant",   session.getAttribute("exam_etudiant"));
        req.setAttribute("anneeUniv",  session.getAttribute("exam_annee"));
        req.getRequestDispatcher("/views/examen/run.jsp").forward(req, resp);
    }

    // ─── Traiter la réponse de l'étudiant ─────────────────
    @SuppressWarnings("unchecked")
    private void processAnswer(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {

        HttpSession    session   = req.getSession();
        List<QCM>      questions = (List<QCM>) session.getAttribute("exam_questions");
        int            current   = (Integer)   session.getAttribute("exam_current");
        int            score     = (Integer)   session.getAttribute("exam_score");
        List<Map<String,String>> answers = (List<Map<String,String>>) session.getAttribute("exam_answers");

        String selected = req.getParameter("reponse");
        QCM    q        = questions.get(current);

        // Vérification de la réponse
        boolean correct = q.getBonne().equals(selected);
        if (correct) score++;

        // Sauvegarder le détail de la réponse
        Map<String,String> detail = new LinkedHashMap<>();
        detail.put("question",       q.getQuestion());
        detail.put("selected",       selected);
        detail.put("selectedTexte",  getTexteReponse(q, selected));
        detail.put("bonne",          q.getBonne());
        detail.put("bonneTexte",     q.getTexteBonneReponse());
        detail.put("correct",        String.valueOf(correct));
        answers.add(detail);

        session.setAttribute("exam_score",   score);
        session.setAttribute("exam_current", current + 1);
        session.setAttribute("exam_answers", answers);

        // Redirection : question suivante ou résultat
        if (current + 1 >= questions.size()) {
            resp.sendRedirect(req.getContextPath() + "/examens?action=result");
        } else {
            resp.sendRedirect(req.getContextPath() + "/examens?action=run");
        }
    }

    // ─── Sauvegarder le résultat en base ──────────────────
    @SuppressWarnings("unchecked")
    private void saveResult(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {

        HttpSession session   = req.getSession();
        Etudiant    etudiant  = (Etudiant) session.getAttribute("exam_etudiant");
        String      annee     = (String)   session.getAttribute("exam_annee");
        int         score     = (Integer)  session.getAttribute("exam_score");

        // Insertion en base
        Examen ex = new Examen();
        ex.setNumEtudiant(etudiant.getNumEtudiant());
        ex.setAnneeUniv(annee);
        ex.setNote(score);
        examenDAO.insert(ex);

        // Préparer l'email simulé
        req.setAttribute("emailDest",    etudiant.getAdrEmail());
        req.setAttribute("emailNom",     etudiant.getNom() + " " + etudiant.getPrenoms());
        req.setAttribute("emailNote",    score);
        req.setAttribute("emailAnnee",   annee);
        req.setAttribute("emailMention", getMention(score));

        // Nettoyer la session
        session.removeAttribute("exam_etudiant");
        session.removeAttribute("exam_annee");
        session.removeAttribute("exam_questions");
        session.removeAttribute("exam_current");
        session.removeAttribute("exam_score");
        session.removeAttribute("exam_answers");

        req.getRequestDispatcher("/views/examen/mail.jsp").forward(req, resp);
    }

    // ─── Helpers ──────────────────────────────────────────
    private String getTexteReponse(QCM q, String key) {
        if (key == null) return "";
        switch (key) {
            case "reponse1": return q.getReponse1();
            case "reponse2": return q.getReponse2();
            case "reponse3": return q.getReponse3();
            case "reponse4": return q.getReponse4();
            default:         return "";
        }
    }

    private String getMention(int note) {
        if (note >= 9) return "Très bien";
        if (note >= 7) return "Bien";
        if (note >= 5) return "Passable";
        return "Insuffisant";
    }
}
