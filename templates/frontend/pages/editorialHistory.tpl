{**
 * templates/frontend/pages/editorialHistory.tpl
 *
 * Copyright (c) 2025 Simon Fraser University
 * Copyright (c) 2025 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Display context's editorial history page.
 *
 *}
{include file="frontend/components/header.tpl" pageTitle="common.editorialHistory"}

<main class="container main__content page_masthead" id="main">
    <div class="row">
        <div class="offset-md-1 col-md-10 offset-lg-2 col-lg-8">
            <header class="main__header">
                <h1 class="main__title">
                    <span>{translate key="common.editorialHistory.page"}</span>
                </h1>
            </header>

            <p>{translate key="common.editorialHistory.page.description"}</p>
            {foreach from=$mastheadRoles item="mastheadRole"}
                {if array_key_exists($mastheadRole->id, $mastheadUsers)}
                    <h2>{$mastheadRole->getLocalizedData('name')|escape}</h2>
                    <ul class="user_listing" role="list">
                        {foreach from=$mastheadUsers[$mastheadRole->id] item="mastheadUser"}
                            <li>
                                {strip}
                                    <span class="date_start">
                                        {foreach name="services" from=$mastheadUser['services'] item="service"}
                                            {translate key="common.fromUntil" from=$service['dateStart'] until=$service['dateEnd']}
                                            {if !$smarty.foreach.services.last}{translate key="common.commaListSeparator"}{/if}
                                        {/foreach}
                                    </span>
                                    <span class="name">
                                        {$mastheadUser['user']->getFullName()|escape}
                                            {if $mastheadUser['user']->getData('orcid') && $mastheadUser['user']->getData('orcidAccessToken')}
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
        </div>
    </div>
    {include file="frontend/components/editLink.tpl" page="management" op="settings" path="context" anchor="masthead" sectionTitleKey="common.editorialHistory"}
    {$currentContext->getLocalizedData('editorialHistory')}
</main>

{include file="frontend/components/footer.tpl"}
