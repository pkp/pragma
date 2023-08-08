{if $citation}
	<section>
		<h2>{translate key="submission.howToCite"}</h2>
		<p></p>
		<div id="citationOutput" role="region" aria-live="polite" style="margin-bottom: 1.25rem;">
            {$citation}
		</div>
		<div class="dropdown">
			<button class="btn btn-primary dropdown-toggle" type="button" id="cslCitationFormatsButton" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" data-csl-dropdown="true">
                {translate key="submission.howToCite.citationFormats"}
			</button>
			<ul class="dropdown-menu" aria-labelledby="cslCitationFormatsButton">
                {foreach from=$citationStyles item="citationStyle"}
					<li class="dropdown-item">
						<a
								aria-controls="citationOutput"
								href="{url page="citationstylelanguage" op="get" path=$citationStyle.id params=$citationArgs}"
								data-load-citation
								data-json-href="{url page="citationstylelanguage" op="get" path=$citationStyle.id params=$citationArgsJson}"
						>
                            {$citationStyle.title|escape}
						</a>
					</li>
                {/foreach}
			</ul>
		</div>

        {if count($citationDownloads)}
			<hr>
			<h3>
                {translate key="submission.howToCite.downloadCitation"}
			</h3>
			<ul>
                {foreach from=$citationDownloads item="citationDownload"}
					<li>
						<a href="{url page="citationstylelanguage" op="download" path=$citationDownload.id params=$citationArgs}">
                            {$citationDownload.title|escape}
						</a>
					</li>
                {/foreach}
			</ul>
        {/if}
	</section>
{/if}