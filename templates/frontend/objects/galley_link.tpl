{**
 * templates/frontend/objects/galley_link.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief View of a galley object as a link to view or download the galley, to be used
 *  in a list of galleys.
 *
 * @uses $galley Galley
 * @uses $parent Issue|Article Object which these galleys are attached to
 * @uses $publication Publication Optionally the publication (version) to which this galley is attached
 * @uses $isSupplementary bool Is this a supplementary file?
 * @uses $hasAccess bool Can this user access galleys for this context?
 * @uses $restrictOnlyPdf bool Is access only restricted to PDF galleys?
 * @uses $purchaseArticleEnabled bool Can this article be purchased?
 * @uses $currentJournal Journal The current journal context
 * @uses $journalOverride Journal An optional argument to override the current
 *       journal with a specific context
 *}

{* Override the $currentJournal context if desired *}
{if $journalOverride}
    {assign var="currentJournal" value=$journalOverride}
{/if}

{* Determine galley type and URL op *}
{if $galley->isPdfGalley()}
    {assign var="type" value="pdf"}
{else}
    {assign var="type" value="file"}
{/if}

{* Get page and parentId for URL *}
{if $parent instanceOf Issue}
    {assign var="page" value="issue"}
    {assign var="parentId" value=$parent->getBestIssueId()}
    {assign var="path" value=$parentId|to_array:$galley->getBestGalleyId()}
{else}
    {assign var="page" value="article"}
    {if $publication}
        {if $publication->getId() !== $parent->getData('currentPublicationId')}
            {* Get a versioned link if we have an older publication *}
            {assign var="path" value=$parent->getBestId()|to_array:"version":$publication->getId():$galley->getBestGalleyId()}
        {else}
            {assign var="parentId" value=$publication->getData('urlPath')|default:$article->getId()}
            {assign var="path" value=$parentId|to_array:$galley->getBestGalleyId()}
        {/if}
    {else}
        {assign var="path" value=$parent->getBestId()|to_array:$galley->getBestGalleyId()}
    {/if}
{/if}

{* Get user access flag *}
{if !$hasAccess}
    {if $restrictOnlyPdf && $type=="pdf"}
        {assign var=restricted value="1"}
    {elseif !$restrictOnlyPdf}
        {assign var=restricted value="1"}
    {/if}
{/if}

<a class="{if $isSupplementary}btn btn-secondary galley_supplementary{else}btn btn-secondary{/if} {$type|escape}{if $restricted} restricted{/if}"
   href="{url page=$page op="view" path=$path}">

    {* Add some screen reader text to indicate if a galley is restricted *}
    {if $restricted}
		<span class="visually-hidden">
			{if $purchaseArticleEnabled}
                {translate key="reader.subscriptionOrFeeAccess"}
            {else}
                {translate key="reader.subscriptionAccess"}
            {/if}
		</span>
    {/if}

    {$galley->getGalleyLabel()|escape}

    {if $restricted && $purchaseFee && $purchaseCurrency}
        {translate key="reader.purchasePrice" price=$purchaseFee currency=$purchaseCurrency}
    {/if}
</a>
