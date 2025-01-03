{**
 * templates/frontend/pages/orcidAbout.tpl
 *
 * Copyright (c) 2014-2024 Simon Fraser University
 * Copyright (c) 2000-2024 John Willinsky
 * Copyright (c) 2018-2019 University Library Heidelberg
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * Page template to display from the OrcidHandler to show information/overview about ORCID functionality for users.
 *}
{include file="frontend/components/header.tpl"}

<main class="container main__content" id="main">
    <div class="row">
        <div class="offset-md-1 col-md-10 offset-lg-2 col-lg-8">
            <header class="main__header">
                <h1 class="main__title">
                    <span>{translate key="orcid.about.title"}</span>
                </h1>
            </header>

            <div class="page-content">
                <p class="description">
                    {translate key="orcid.about.orcidExplanation"}
                </p>
                <h2>{translate key="orcid.about.howAndWhy.title"}</h2>
                {if $isMemberApi}
                    <p class="description">
                        {translate key="orcid.about.howAndWhyMemberAPI"}
                    </p>
                {else}
                    <p class="description">
                        {translate key="orcid.about.howAndWhyPublicAPI"}
                    </p>
                {/if}
                <h2>{translate key="orcid.about.display.title"}</h2>
                <p class="description">
                    {translate key="orcid.about.display"}
                </p>
            </div>
        </div>
    </div>
</main>

{include file="frontend/components/footer.tpl"}
