package com.gestionqcm.dao;

import com.gestionqcm.model.QCM;
import com.gestionqcm.util.DBConnection;

import java.sql.*;
import java.util.*;

/** Toutes les opérations SQL sur la table QCM. */
public class QCMDAO {

    // ─── Lister toutes les questions ─────────────────────
    public List<QCM> findAll() throws SQLException {
        List<QCM> list = new ArrayList<>();
        String sql = "SELECT * FROM QCM ORDER BY num_quest";
        try (Connection c = DBConnection.getConnection();
             Statement  s = c.createStatement();
             ResultSet  r = s.executeQuery(sql)) {
            while (r.next()) list.add(map(r));
        }
        return list;
    }

    // ─── Recherche par mot-clé ───────────────────────────
    public List<QCM> search(String keyword) throws SQLException {
        List<QCM> list = new ArrayList<>();
        String sql = "SELECT * FROM QCM WHERE question LIKE ? ORDER BY num_quest";
        try (Connection c  = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            try (ResultSet r = ps.executeQuery()) {
                while (r.next()) list.add(map(r));
            }
        }
        return list;
    }

    // ─── Trouver par ID ──────────────────────────────────
    public QCM findById(int numQuest) throws SQLException {
        String sql = "SELECT * FROM QCM WHERE num_quest = ?";
        try (Connection c  = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, numQuest);
            try (ResultSet r = ps.executeQuery()) {
                if (r.next()) return map(r);
            }
        }
        return null;
    }

    // ─── 10 questions aléatoires pour l'examen ──────────
    public List<QCM> findRandom(int nb) throws SQLException {
        List<QCM> list = new ArrayList<>();
        String sql = "SELECT * FROM QCM ORDER BY RAND() LIMIT ?";
        try (Connection c  = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, nb);
            try (ResultSet r = ps.executeQuery()) {
                while (r.next()) list.add(map(r));
            }
        }
        return list;
    }

    // ─── Compter le total ────────────────────────────────
    public int countAll() throws SQLException {
        String sql = "SELECT COUNT(*) FROM QCM";
        try (Connection c = DBConnection.getConnection();
             Statement  s = c.createStatement();
             ResultSet  r = s.executeQuery(sql)) {
            if (r.next()) return r.getInt(1);
        }
        return 0;
    }

    // ─── Insérer ─────────────────────────────────────────
    public boolean insert(QCM q) throws SQLException {
        String sql = "INSERT INTO QCM (question,reponse1,reponse2,reponse3,reponse4,bonne) VALUES (?,?,?,?,?,?)";
        try (Connection c  = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, q.getQuestion());
            ps.setString(2, q.getReponse1());
            ps.setString(3, q.getReponse2());
            ps.setString(4, q.getReponse3());
            ps.setString(5, q.getReponse4());
            ps.setString(6, q.getBonne());
            return ps.executeUpdate() > 0;
        }
    }

    // ─── Modifier ────────────────────────────────────────
    public boolean update(QCM q) throws SQLException {
        String sql = "UPDATE QCM SET question=?,reponse1=?,reponse2=?,reponse3=?,reponse4=?,bonne=? WHERE num_quest=?";
        try (Connection c  = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, q.getQuestion());
            ps.setString(2, q.getReponse1());
            ps.setString(3, q.getReponse2());
            ps.setString(4, q.getReponse3());
            ps.setString(5, q.getReponse4());
            ps.setString(6, q.getBonne());
            ps.setInt(7, q.getNumQuest());
            return ps.executeUpdate() > 0;
        }
    }

    // ─── Supprimer ───────────────────────────────────────
    public boolean delete(int numQuest) throws SQLException {
        String sql = "DELETE FROM QCM WHERE num_quest = ?";
        try (Connection c  = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, numQuest);
            return ps.executeUpdate() > 0;
        }
    }

    // ─── Mapping ResultSet → QCM ─────────────────────────
    private QCM map(ResultSet r) throws SQLException {
        return new QCM(
            r.getInt("num_quest"),
            r.getString("question"),
            r.getString("reponse1"),
            r.getString("reponse2"),
            r.getString("reponse3"),
            r.getString("reponse4"),
            r.getString("bonne")
        );
    }
}
