import React, { useEffect } from 'react';
import { Redirect, useHistory } from 'react-router-dom';
import { connect } from 'react-redux';

import { api_auth } from '../../api';

// TODO: Create .env file and move client details there
const Auth = ({ session, token }) => {
  const history = useHistory();

  useEffect(() => {
    const url = window.location.href;
    
    if (url.includes("?code=")) {
      let code = url.split("?code=")[1];

      // FIX: OAUTH bug — don't let it redirect to home without setting token first
      api_auth(code).then(() => {
        history.push('/');
      });
    }
  });

  if (!session) {
    return (
      <section>
        <h4>Please login to continue</h4>
      </section>
    )
  }

  if (token) {
    return (
      <Redirect to={'/'} />
    )
  }

  return (
    <section>
      <a
        href="https://accounts.spotify.com/authorize?client_id=006d7532893548a89635c04a92dd1fe6&response_type=code&redirect_uri=http://localhost:3000/auth&scope=user-top-read%20user-top-read%20playlist-modify-public"
      >
        Login with Spotify
      </a>
    </section>
  );
}

export default connect(({ session, token }) => ({ session, token }))(Auth)