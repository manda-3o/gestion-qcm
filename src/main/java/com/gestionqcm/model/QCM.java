package com.gestionqcm.model;

/** Modèle de la table QCM. */
public class QCM {

    private int    numQuest;
    private String question;
    private String reponse1;
    private String reponse2;
    private String reponse3;
    private String reponse4;
    private String bonne;   // "reponse1" | "reponse2" | "reponse3" | "reponse4"

    public QCM() {}

    public QCM(int numQuest, String question,
               String reponse1, String reponse2, String reponse3, String reponse4,
               String bonne) {
        this.numQuest = numQuest;
        this.question = question;
        this.reponse1 = reponse1;
        this.reponse2 = reponse2;
        this.reponse3 = reponse3;
        this.reponse4 = reponse4;
        this.bonne    = bonne;
    }

    // ─── Getters / Setters ─────────────────────────────────
    public int    getNumQuest()             { return numQuest; }
    public void   setNumQuest(int v)        { this.numQuest = v; }

    public String getQuestion()             { return question; }
    public void   setQuestion(String v)     { this.question = v; }

    public String getReponse1()             { return reponse1; }
    public void   setReponse1(String v)     { this.reponse1 = v; }

    public String getReponse2()             { return reponse2; }
    public void   setReponse2(String v)     { this.reponse2 = v; }

    public String getReponse3()             { return reponse3; }
    public void   setReponse3(String v)     { this.reponse3 = v; }

    public String getReponse4()             { return reponse4; }
    public void   setReponse4(String v)     { this.reponse4 = v; }

    public String getBonne()                { return bonne; }
    public void   setBonne(String v)        { this.bonne = v; }

    /** Retourne le texte de la bonne réponse. */
    public String getTexteBonneReponse() {
        switch (bonne == null ? "" : bonne) {
            case "reponse1": return reponse1;
            case "reponse2": return reponse2;
            case "reponse3": return reponse3;
            case "reponse4": return reponse4;
            default:         return "";
        }
    }

    /** Retourne le libellé court (R1…R4). */
    public String getBonneLabel() {
        if (bonne == null) return "";
        return bonne.replace("reponse", "R");
    }
}
