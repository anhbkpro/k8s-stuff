-- YAML schemas for Kubernetes + Istio (completion, hover, validation).
--
-- The lazyvim yaml extra already installs yaml-language-server + SchemaStore.
-- This override tells yamlls which schema a file is:
--   * core K8s resources  -> yamlls' built-in "kubernetes" schema
--   * Istio / other CRDs  -> JSON schemas from datreeio/CRDs-catalog
--
-- Two ways to attach an Istio schema:
--   1. Per file (most reliable) — drop a modeline at the top of the YAML:
--        # yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/networking.istio.io/virtualservice_v1beta1.json
--   2. Repo-wide — map a glob to a schema URL in `schemas` below.
--
-- Requires network access the first time a schema is fetched (yamlls caches it).
local CRD = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main"

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        yamlls = {
          settings = {
            yaml = {
              -- Keep SchemaStore's catalog on (LazyVim populates schemas from it);
              -- these entries are merged in on top.
              schemas = {
                -- Core Kubernetes: apply to common manifest locations. Tighten
                -- or widen these globs to match where you keep manifests. Avoid
                -- a bare "*.yaml" or it'll fight Istio/CRD files.
                kubernetes = {
                  "k8s/**/*.yaml",
                  "kubernetes/**/*.yaml",
                  "manifests/**/*.yaml",
                  "*.k8s.yaml",
                },

                -- Istio networking.istio.io
                [CRD .. "/networking.istio.io/virtualservice_v1beta1.json"] = "**/virtualservice*.yaml",
                [CRD .. "/networking.istio.io/gateway_v1beta1.json"] = "**/gateway*.yaml",
                [CRD .. "/networking.istio.io/destinationrule_v1beta1.json"] = "**/destinationrule*.yaml",
                [CRD .. "/networking.istio.io/serviceentry_v1beta1.json"] = "**/serviceentry*.yaml",
                [CRD .. "/networking.istio.io/sidecar_v1beta1.json"] = "**/sidecar*.yaml",
                [CRD .. "/networking.istio.io/envoyfilter_v1alpha3.json"] = "**/envoyfilter*.yaml",

                -- Istio security.istio.io
                [CRD .. "/security.istio.io/authorizationpolicy_v1.json"] = "**/authorizationpolicy*.yaml",
                [CRD .. "/security.istio.io/peerauthentication_v1.json"] = "**/peerauthentication*.yaml",
                [CRD .. "/security.istio.io/requestauthentication_v1.json"] = "**/requestauthentication*.yaml",

                -- Istio telemetry.istio.io
                [CRD .. "/telemetry.istio.io/telemetry_v1.json"] = "**/telemetry*.yaml",
              },
              -- Enable schema-driven completion + validation everywhere.
              validate = true,
              completion = true,
              hover = true,
            },
          },
        },
      },
    },
  },
}
