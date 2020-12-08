{**
 * templates/frontend/pages/indexSite.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Site index page.
 * @uses $journals array of Journal objects
 *
 *}
{include file="frontend/components/header.tpl"}

<main class="container main__content" id="main">
	<div class="row">
		<div class="offset-md-1 col-md-10 offset-lg-2 col-lg-8">
			<header class="main__header">
				<h2 class="main__title">
					{translate key="context.contexts"}
				</h2>
				{if $about}
					<div>
						{$about|strip_unsafe_html|nl2br}
					</div>
				{/if}
			</header>

			<div>
				{if !$journals|@count}
					{translate key="site.noJournals"}
				{else}
					{assign var="journalKey" value=0}
					{assign var="countItems" value=count($journals)}
					{foreach from=$journals item=journal}
						{capture assign="url"}{url journal=$journal->getPath()}{/capture}
						{assign var="thumb" value=$journal->getLocalizedSetting('journalThumbnail')}
						{assign var="description" value=$journal->getLocalizedDescription()}
						{assign var="journalKey" value=$journalKey+1}
						<article>
							{if $thumb}
								<div>
									<a href="{$url|escape}">
										<img src="{$journalFilesPath}{$journal->getId()}/{$thumb.uploadName|escape:"url"}"{if $thumb.altText} alt="{$thumb.altText|escape|default:''}"{/if} class="img-fluid">
									</a>
								</div>
							{/if}

							<h3>
								<a href="{$url|escape}" rel="bookmark">
									{$journal->getLocalizedName()}
								</a>
							</h3>
							{if $description}
								<div>
									{$description|nl2br}
								</div>
							{/if}
							<p>
								<a class="btn btn-primary"  href="{$url|escape}">
									{translate key="site.journalView"}
								</a>
								<a class="btn btn-secondary" href="{url|escape journal=$journal->getPath() page="issue" op="current"}">
									{translate key="site.journalCurrent"}
								</a>
							</p>
						</article>
						{if $journalKey < $countItems+1}<hr>{/if}
					{/foreach}
				{/if}
			</div>
		</div>
	</div>

</main>

{include file="frontend/components/footer.tpl"}
