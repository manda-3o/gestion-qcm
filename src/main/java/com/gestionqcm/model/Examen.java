package com.gestionqcm.model;

/** Modèle de la table EXAMEN. */
public class Examen {

    private int    numExam;
    private String numEtudiant;
    private String anneeUniv;
    private int    note;

    // Jointure avec ETUDIANT (chargé en lecture)
    private String nomEtudiant;
    private String prenomsEtudiant;
    private String niveauEtudiant;
    private String emailEtudiant;

    public Examen() {}

    public Examen(int numExam, String numEtudiant, String anneeUniv, int note) {
        this.numExam     = numExam;
        this.numEtudiant = numEtudiant;
        this.anneeUniv   = anneeUniv;
        this.note        = note;
    }

    // ─── Getters / Setters ─────────────────────────────────
    public int    getNumExam()                  { return numExam; }
    public void   setNumExam(int v)             { this.numExam = v; }

    public String getNumEtudiant()              { return numEtudiant; }
    public void   setNumEtudiant(String v)      { this.numEtudiant = v; }

    public String getAnneeUniv()                { return anneeUniv; }
    public void   setAnneeUniv(String v)        { this.anneeUniv = v; }

    public int    getNote()                     { return note; }
    public void   setNote(int v)                { this.note = v; }

    public String getNomEtudiant()              { return nomEtudiant; }
    public void   setNomEtudiant(String v)      { this.nomEtudiant = v; }

    public String getPrenomsEtudiant()          { return prenomsEtudiant; }
    public void   setPrenomsEtudiant(String v)  { this.prenomsEtudiant = v; }

    public String getNiveauEtudiant()           { return niveauEtudiant; }
    public void   setNiveauEtudiant(String v)   { this.niveauEtudiant = v; }

    public String getEmailEtudiant()            { return emailEtudiant; }
    public void   setEmailEtudiant(String v)    { this.emailEtudiant = v; }

    /** Mention selon la note sur 10. */
    public String getMention() {
        if (note >= 9) return "Très bien";
        if (note >= 7) return "Bien";
        if (note >= 5) return "Passable";
        return "Insuffisant";
    }

    /** Classe CSS Bootstrap selon la note. */
    public String getMentionClass() {
        if (note >= 9) return "success";
        if (note >= 7) return "primary";
        if (note >= 5) return "warning";
        return "danger";
    }

    public String getNomComplet() {
        return (nomEtudiant != null ? nomEtudiant : "") + " " +
               (prenomsEtudiant != null ? prenomsEtudiant : "");
    }
}
