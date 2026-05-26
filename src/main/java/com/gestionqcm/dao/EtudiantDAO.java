package com.gestionqcm.dao;

import com.gestionqcm.model.Etudiant;
import com.gestionqcm.util.DBConnection;

import java.sql.*;
import java.util.*;

/** Toutes les opérations SQL sur la table ETUDIANT. */
public class EtudiantDAO {

    // ─── Lister tous les étudiants ────────────────────────
    public List<Etudiant> findAll() throws SQLException {
        List<Etudiant> list = new ArrayList<>();
        String sql = "SELECT * FROM ETUDIANT ORDER BY Nom, Prenoms";
        try (Connection c = DBConnection.getConnection();
             Statement  s = c.createStatement();
             ResultSet  r = s.executeQuery(sql)) {
            while (r.next()) list.add(map(r));
        }
        return list;
    }

    // ─── Recherche LIKE (numéro OU nom) ──────────────────
    public List<Etudiant> search(String keyword) throws SQLException {
        List<Etudiant> list = new ArrayList<>();
        String sql = "SELECT * FROM ETUDIANT " +
                     "WHERE num_etudiant LIKE ? OR Nom LIKE ? OR Prenoms LIKE ? " +
                     "ORDER BY Nom, Prenoms";
        try (Connection c  = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            String like = "%" + keyword + "%";
            ps.setString(1, like);
            ps.setString(2, like);
            ps.setString(3, like);
            try (ResultSet r = ps.executeQuery()) {
                while (r.next()) list.add(map(r));
            }
        }
        return list;
    }

    // ─── Lister par niveau ────────────────────────────────
    public List<Etudiant> findByNiveau(String niveau) throws SQLException {
        List<Etudiant> list = new ArrayList<>();
        String sql = "SELECT * FROM ETUDIANT WHERE Niveau = ? ORDER BY Nom, Prenoms";
        try (Connection c  = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, niveau);
            try (ResultSet r = ps.executeQuery()) {
                while (r.next()) list.add(map(r));
            }
        }
        return list;
    }

    // ─── Trouver par numéro ───────────────────────────────
    public Etudiant findById(String numEtudiant) throws SQLException {
        String sql = "SELECT * FROM ETUDIANT WHERE num_etudiant = ?";
        try (Connection c  = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, numEtudiant);
            try (ResultSet r = ps.executeQuery()) {
                if (r.next()) return map(r);
            }
        }
        return null;
    }

    // ─── Compter par niveau ───────────────────────────────
    public int countByNiveau(String niveau) throws SQLException {
        String sql = "SELECT COUNT(*) FROM ETUDIANT WHERE Niveau = ?";
        try (Connection c  = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, niveau);
            try (ResultSet r = ps.executeQuery()) {
                if (r.next()) return r.getInt(1);
            }
        }
        return 0;
    }

    // ─── Compter total ────────────────────────────────────
    public int countAll() throws SQLException {
        String sql = "SELECT COUNT(*) FROM ETUDIANT";
        try (Connection c = DBConnection.getConnection();
             Statement  s = c.createStatement();
             ResultSet  r = s.executeQuery(sql)) {
            if (r.next()) return r.getInt(1);
        }
        return 0;
    }

    // ─── Insérer ──────────────────────────────────────────
    public boolean insert(Etudiant e) throws SQLException {
        String sql = "INSERT INTO ETUDIANT VALUES (?,?,?,?,?)";
        try (Connection c  = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, e.getNumEtudiant());
            ps.setString(2, e.getNom());
            ps.setString(3, e.getPrenoms());
            ps.setString(4, e.getNiveau());
            ps.setString(5, e.getAdrEmail());
            return ps.executeUpdate() > 0;
        }
    }

    // ─── Modifier ─────────────────────────────────────────
    public boolean update(Etudiant e) throws SQLException {
        String sql = "UPDATE ETUDIANT SET Nom=?, Prenoms=?, Niveau=?, adr_email=? WHERE num_etudiant=?";
        try (Connection c  = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, e.getNom());
            ps.setString(2, e.getPrenoms());
            ps.setString(3, e.getNiveau());
            ps.setString(4, e.getAdrEmail());
            ps.setString(5, e.getNumEtudiant());
            return ps.executeUpdate() > 0;
        }
    }

    // ─── Supprimer ────────────────────────────────────────
    public boolean delete(String numEtudiant) throws SQLException {
        String sql = "DELETE FROM ETUDIANT WHERE num_etudiant = ?";
        try (Connection c  = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, numEtudiant);
            return ps.executeUpdate() > 0;
        }
    }

    // ─── Vérifier existence ───────────────────────────────
    public boolean exists(String numEtudiant) throws SQLException {
        String sql = "SELECT COUNT(*) FROM ETUDIANT WHERE num_etudiant = ?";
        try (Connection c  = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, numEtudiant);
            try (ResultSet r = ps.executeQuery()) {
                if (r.next()) return r.getInt(1) > 0;
            }
        }
        return false;
    }

    // ─── Mapping ResultSet → Etudiant ─────────────────────
    private Etudiant map(ResultSet r) throws SQLException {
        return new Etudiant(
            r.getString("num_etudiant"),
            r.getString("Nom"),
            r.getString("Prenoms"),
            r.getString("Niveau"),
            r.getString("adr_email")
        );
    }
}
