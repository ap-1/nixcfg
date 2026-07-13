# PGP

OpenPGP is handled by [Sequoia](https://sequoia-pgp.org/) rather than GnuPG, chiefly because Sequoia has already added support for post-quantum keys. The `sq` command line manages keys, and the [Chameleon](https://gitlab.com/sequoia-pgp/sequoia-chameleon-gnupg) provides a drop-in replacement for `gpg`.

GnuPG stays installed only to supply the agent and helper daemons that the Chameleon defers to. The agent caches passphrases and prompts through a graphical or terminal pinentry depending on the host. git and jujutsu sign commits through the Chameleon.

## Post-quantum

The primary key is an ML-DSA-65 + Ed25519 composite, with an ML-KEM-768 + X25519 encryption subkey, both defined by [RFC 9980](https://www.rfc-editor.org/rfc/rfc9980) (post-quantum cryptography in OpenPGP). Both `sq` and the Chameleon understand these algorithms, so they can generate, list, and operate on the key.

Its secret material is held in Sequoia's own keystore, while the older classical keys remain with the agent. The Chameleon reaches both.

## Mailvelope

Mailvelope reuses this keyring through its [GnuPG integration](https://github.com/mailvelope/mailvelope/wiki/Mailvelope-GnuPG-integration) instead of its bundled OpenPGP implementation, which cannot handle the post-quantum key.

Firefox speaks to a native-messaging bridge that drives the Chameleon, so the browser can encrypt to and decrypt with the key. It is enabled on the desktop hosts; the GnuPG backend is then selected from the Mailvelope dashboard.
