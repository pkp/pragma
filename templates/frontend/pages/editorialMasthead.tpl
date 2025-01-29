{**
 * templates/frontend/pages/editorialMasthead.tpl
 *
 * Copyright (c) 2025 Simon Fraser University
 * Copyright (c) 2025 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Display context's editorial masthead page.
 *
 *}
{include file="frontend/components/header.tpl" pageTitle="common.editorialMasthead"}

<main class="container main__content page_masthead" id="main">
    <div class="row">
        <div class="offset-md-1 col-md-10 offset-lg-2 col-lg-8">
            <header class="main__header">
                <h1 class="main__title">
                    <span>{translate key="common.editorialMasthead"}<span>
                </h1>
            </header>

            {foreach from=$mastheadRoles item="mastheadRole"}
                {if array_key_exists($mastheadRole->id, $mastheadUsers)}
                    <h2>{$mastheadRole->getLocalizedData('name')|escape}</h2>
                    <ul class="user_listing" role="list">
                        {foreach from=$mastheadUsers[$mastheadRole->id] item="mastheadUser"}
                            <li>
                                {strip}
                                    <span class="date_start">{translate key="common.fromUntil" from=$mastheadUser['dateStart'] until=""}</span>
                                    <span class="name">
                                        {$mastheadUser['user']->getFullName()|escape}
                                            {if $mastheadUser['user']->getData('orcid') && $mastheadUser['user']->hasVerifiedOrcid()}
                                                <span class="orcid">
                                                    <a href="{$mastheadUser['user']->getData('orcid')|escape}" target="_blank" aria-label="{translate key="common.editorialHistory.page.orcidLink" name=$mastheadUser['user']->getFullName()|escape}">
                                                        {$orcidIcon}
                                                    </a>
                                                </span>
                                            {/if}
                                    </span>
                                    {if !empty($mastheadUser['user']->getLocalizedData('affiliation'))}
                                        <span class="affiliation">{$mastheadUser['user']->getLocalizedData('affiliation')|escape}</span>
                                    {/if}
                                {/strip}
                            </li>
                        {/foreach}
                    </ul>
                {/if}
            {/foreach}
			<p>
				{capture assign=editorialHistoryUrl}{url page="about" op="editorialHistory" router=\PKP\core\PKPApplication::ROUTE_PAGE}{/capture}
				{translate key="about.editorialMasthead.linkToEditorialHistory" url=$editorialHistoryUrl}
			</p>
            <hr>

            {if $reviewers->count()}
                <h2>{translate key="common.editorialMasthead.peerReviewers"}</h2>
                <p>{translate key="common.editorialMasthead.peerReviewers.description" year=$previousYear}</p>
                <ul class="user_listing" role="list">
                    {foreach from=$reviewers item="reviewer"}
                        <li>
                            {strip}
                                <span class="name">
                                {$reviewer->getFullName()|escape}
                                {if $reviewer->getData('orcid') && $reviewer->hasVerifiedOrcid()}
                                    <span class="orcid">
                                        <a href="{$reviewer->getData('orcid')|escape}" target="_blank" aria-label="{translate key="common.editorialHistory.page.orcidLink" name=$reviewer->getFullName()|escape}">
                                            {$orcidIcon}
                                        </a>
                                    </span>
                                {/if}
                                </span>
                                {if !empty($reviewer->getLocalizedData('affiliation'))}
                                    <span class="affiliation">{$reviewer->getLocalizedData('affiliation')|escape}</span>
                                {/if}
                            {/strip}
                        </li>
                    {/foreach}
                </ul>
            {/if}
        </div>
    </div>
</main>

{include file="frontend/components/footer.tpl"}
