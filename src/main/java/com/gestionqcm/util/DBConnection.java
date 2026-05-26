package com.gestionqcm.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Utilitaire de connexion à la base de données MySQL.
 * Modifiez URL, USER et PASSWORD selon votre configuration.
 */
public class DBConnection {

    private static final String URL      = "jdbc:mysql://localhost:3306/gestion_qcm?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
    private static final String USER     = "root";
    private static final String PASSWORD = "";  // ← Votre mot de passe MySQL

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Driver MySQL introuvable : " + e.getMessage());
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
