package com.gestionqcm.dao;

import com.gestionqcm.model.Examen;
import com.gestionqcm.util.DBConnection;

import java.sql.*;
import java.util.*;

/** Toutes les opérations SQL sur la table EXAMEN. */
public class ExamenDAO {

    // ─── Lister tous les examens avec JOIN ETUDIANT ──────
    public List<Examen> findAll() throws SQLException {
        List<Examen> list = new ArrayList<>();
        String sql = "SELECT EX.*, E.Nom, E.Prenoms, E.Niveau, E.adr_email " +
                     "FROM EXAMEN EX JOIN ETUDIANT E ON EX.num_etudiant = E.num_etudiant " +
                     "ORDER BY EX.num_exam DESC";
        try (Connection c = DBConnection.getConnection();
             Statement  s = c.createStatement();
             ResultSet  r = s.executeQuery(sql)) {
            while (r.next()) list.add(mapJoin(r));
        }
        return list;
    }

    // ─── Filtrer par année universitaire ─────────────────
    public List<Examen> findByAnnee(String annee) throws SQLException {
        List<Examen> list = new ArrayList<>();
        String sql = "SELECT EX.*, E.Nom, E.Prenoms, E.Niveau, E.adr_email " +
                     "FROM EXAMEN EX JOIN ETUDIANT E ON EX.num_etudiant = E.num_etudiant " +
                     "WHERE EX.Annee_univ = ? ORDER BY EX.num_exam DESC";
        try (Connection c  = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, annee);
            try (ResultSet r = ps.executeQuery()) {
                while (r.next()) list.add(mapJoin(r));
            }
        }
        return list;
    }

    // ─── Classement par ordre de mérite (note DESC) ──────
    public List<Examen> getClassement() throws SQLException {
        List<Examen> list = new ArrayList<>();
        String sql = "SELECT EX.num_etudiant, E.Nom, E.Prenoms, E.Niveau, E.adr_email, " +
                     "MAX(EX.note) AS note, COUNT(EX.num_exam) AS nb_examens, " +
                     "AVG(EX.note) AS moyenne, MAX(EX.num_exam) AS num_exam, MAX(EX.Annee_univ) AS Annee_univ " +
                     "FROM EXAMEN EX JOIN ETUDIANT E ON EX.num_etudiant = E.num_etudiant " +
                     "GROUP BY EX.num_etudiant, E.Nom, E.Prenoms, E.Niveau, E.adr_email " +
                     "ORDER BY note DESC, E.Nom ASC";
        try (Connection c = DBConnection.getConnection();
             Statement  s = c.createStatement();
             ResultSet  r = s.executeQuery(sql)) {
            while (r.next()) {
                Examen ex = mapJoin(r);
                ex.setNote(r.getInt("note"));
                list.add(ex);
            }
        }
        return list;
    }

    // ─── Moyenne générale ────────────────────────────────
    public double getMoyenneGenerale() throws SQLException {
        String sql = "SELECT AVG(note) FROM EXAMEN";
        try (Connection c = DBConnection.getConnection();
             Statement  s = c.createStatement();
             ResultSet  r = s.executeQuery(sql)) {
            if (r.next()) return r.getDouble(1);
        }
        return 0;
    }

    // ─── Nombre total d'examens ──────────────────────────
    public int countAll() throws SQLException {
        String sql = "SELECT COUNT(*) FROM EXAMEN";
        try (Connection c = DBConnection.getConnection();
             Statement  s = c.createStatement();
             ResultSet  r = s.executeQuery(sql)) {
            if (r.next()) return r.getInt(1);
        }
        return 0;
    }

    // ─── Taux de réussite ────────────────────────────────
    public int countPassed() throws SQLException {
        String sql = "SELECT COUNT(*) FROM EXAMEN WHERE note >= 5";
        try (Connection c = DBConnection.getConnection();
             Statement  s = c.createStatement();
             ResultSet  r = s.executeQuery(sql)) {
            if (r.next()) return r.getInt(1);
        }
        return 0;
    }

    // ─── Meilleure note ──────────────────────────────────
    public int getBestNote() throws SQLException {
        String sql = "SELECT MAX(note) FROM EXAMEN";
        try (Connection c = DBConnection.getConnection();
             Statement  s = c.createStatement();
             ResultSet  r = s.executeQuery(sql)) {
            if (r.next()) return r.getInt(1);
        }
        return 0;
    }

    // ─── Toutes les années distinctes ────────────────────
    public List<String> getAnnees() throws SQLException {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT Annee_univ FROM EXAMEN ORDER BY Annee_univ DESC";
        try (Connection c = DBConnection.getConnection();
             Statement  s = c.createStatement();
             ResultSet  r = s.executeQuery(sql)) {
            while (r.next()) list.add(r.getString(1));
        }
        return list;
    }

    // ─── Insérer un examen (fin de session) ──────────────
    public boolean insert(Examen ex) throws SQLException {
        String sql = "INSERT INTO EXAMEN (num_etudiant, Annee_univ, note) VALUES (?,?,?)";
        try (Connection c  = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, ex.getNumEtudiant());
            ps.setString(2, ex.getAnneeUniv());
            ps.setInt(3,    ex.getNote());
            return ps.executeUpdate() > 0;
        }
    }

    // ─── Mapping ResultSet → Examen (avec JOIN) ──────────
    private Examen mapJoin(ResultSet r) throws SQLException {
        Examen ex = new Examen(
            r.getInt("num_exam"),
            r.getString("num_etudiant"),
            r.getString("Annee_univ"),
            r.getInt("note")
        );
        ex.setNomEtudiant(r.getString("Nom"));
        ex.setPrenomsEtudiant(r.getString("Prenoms"));
        ex.setNiveauEtudiant(r.getString("Niveau"));
        ex.setEmailEtudiant(r.getString("adr_email"));
        return ex;
    }
}
