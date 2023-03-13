import React from 'react';
import clsx from 'clsx';
import Link from '@docusaurus/Link';
import Layout from '@theme/Layout';
import HomepageFeatures from '@site/src/components/HomepageFeatures';
import Translate, { translate } from '@docusaurus/Translate';

import styles from './index.module.css';

function HomepageHeader() {
  return (
    <header className={clsx('hero hero--primary', styles.heroBanner)}>
      <div className="container">
        <h1 className="hero__title">
          <Translate id="homepage.projectName" description="The name of the project">
            Warp 🚀
          </Translate>
        </h1>
        <p className="hero__subtitle">
          <Translate id="homepage.projectDescription" description="Description of Warp at homepage">
            Bringing Solidity to Starknet at warp speed
          </Translate>
        </p>
        <div className={styles.buttons}>
          <Link className="button button--secondary button--lg" to="/docs/intro">
            <Translate
              id="homepage.documentation.linkLabel"
              description="The label for the link to documentation"
            >
              Documentation 📜
            </Translate>
          </Link>
        </div>
      </div>
    </header>
  );
}

export default function Home() {
  return (
    <Layout
      title={translate({
        message: 'Welcome to Warp',
        description: 'The homepage welcome message',
      })}
      description="Description will go into a meta tag in <head />"
    >
      <HomepageHeader />
      <main>
        <HomepageFeatures />
      </main>
    </Layout>
  );
}
