package com.gestionqcm.model;

/** Modèle de la table ETUDIANT. */
public class Etudiant {

    private String numEtudiant;
    private String nom;
    private String prenoms;
    private String niveau;
    private String adrEmail;

    public Etudiant() {}

    public Etudiant(String numEtudiant, String nom, String prenoms, String niveau, String adrEmail) {
        this.numEtudiant = numEtudiant;
        this.nom         = nom;
        this.prenoms     = prenoms;
        this.niveau      = niveau;
        this.adrEmail    = adrEmail;
    }

    // ─── Getters / Setters ─────────────────────────────────
    public String getNumEtudiant()              { return numEtudiant; }
    public void   setNumEtudiant(String v)      { this.numEtudiant = v; }

    public String getNom()                      { return nom; }
    public void   setNom(String v)              { this.nom = v; }

    public String getPrenoms()                  { return prenoms; }
    public void   setPrenoms(String v)          { this.prenoms = v; }

    public String getNiveau()                   { return niveau; }
    public void   setNiveau(String v)           { this.niveau = v; }

    public String getAdrEmail()                 { return adrEmail; }
    public void   setAdrEmail(String v)         { this.adrEmail = v; }

    /** Initiales pour l'avatar. */
    public String getInitiales() {
        String n = (nom     != null && !nom.isEmpty())     ? String.valueOf(nom.charAt(0))     : "";
        String p = (prenoms != null && !prenoms.isEmpty()) ? String.valueOf(prenoms.charAt(0)) : "";
        return (n + p).toUpperCase();
    }

    @Override
    public String toString() {
        return "Etudiant{" + numEtudiant + ", " + nom + " " + prenoms + ", " + niveau + "}";
    }
}
