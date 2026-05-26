<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GestionQCM — ${pageTitle}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body>

<!-- ═══ SIDEBAR ══════════════════════════════════════════════ -->
<div class="wrapper">
<nav class="sidebar" id="sidebar">
    <div class="sidebar-header">
        <i class="bi bi-mortarboard-fill me-2"></i>GestionQCM
        <div class="sidebar-sub">Projet 1 — Université</div>
    </div>

    <div class="sidebar-section">Navigation</div>

    <a href="${pageContext.request.contextPath}/dashboard"
       class="nav-link ${currentPage == 'dashboard' ? 'active' : ''}">
        <i class="bi bi-speedometer2"></i>Tableau de bord
    </a>

    <div class="sidebar-section">Gestion</div>

    <a href="${pageContext.request.contextPath}/etudiants"
       class="nav-link ${currentPage == 'etudiants' ? 'active' : ''}">
        <i class="bi bi-people"></i>Étudiants
    </a>
    <a href="${pageContext.request.contextPath}/qcm"
       class="nav-link ${currentPage == 'qcm' ? 'active' : ''}">
        <i class="bi bi-journal-bookmark"></i>Questions QCM
    </a>
    <a href="${pageContext.request.contextPath}/niveaux"
       class="nav-link ${currentPage == 'niveaux' ? 'active' : ''}">
        <i class="bi bi-funnel"></i>Liste par Niveau
    </a>

    <div class="sidebar-section">Examens</div>

    <a href="${pageContext.request.contextPath}/examens"
       class="nav-link ${currentPage == 'examens' ? 'active' : ''}">
        <i class="bi bi-clipboard-check"></i>Examens &amp; Notes
    </a>
    <a href="${pageContext.request.contextPath}/classement"
       class="nav-link ${currentPage == 'classement' ? 'active' : ''}">
        <i class="bi bi-trophy"></i>Classement &amp; Stats
    </a>

    <div class="sidebar-footer">
        <div class="sidebar-note">
            <strong>v2.0 — Complet</strong><br>
            CRUD · Examen interactif<br>
            Classement · Email simulé
        </div>
    </div>
</nav>

<!-- ═══ CONTENU PRINCIPAL ════════════════════════════════════ -->
<div class="main-content">
    <!-- Topbar -->
    <div class="topbar">
        <div class="topbar-title">${pageTitle}</div>
        <div class="topbar-badges">
            <span class="badge bg-primary-subtle text-primary">
                <i class="bi bi-people"></i> ${nbEtudiants} étudiants
            </span>
            <span class="badge bg-warning-subtle text-warning">
                <i class="bi bi-journal-bookmark"></i> ${nbQuestions} questions
            </span>
        </div>
    </div>

    <!-- Alertes globales -->
    <c:if test="${not empty erreur}">
        <div class="alert alert-danger alert-dismissible fade show mx-3 mt-3" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>${erreur}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${not empty succes}">
        <div class="alert alert-success alert-dismissible fade show mx-3 mt-3" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i>${succes}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="page-body">
