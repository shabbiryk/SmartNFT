import React from 'react';
import ReactDOM from 'react-dom/client';
import 'bootstrap/dist/css/bootstrap.css';
import App from './App';

describe('App Rendering', () => {
  let container;

  beforeAll(() => {
    container = document.createElement('div');
    document.body.appendChild(container);
  });

  afterAll(() => {
    document.body.removeChild(container);
  });

  it('renders the App component without crashing', () => {
    const root = ReactDOM.createRoot(container);
    root.render(
      <React.StrictMode>
        <App />
      </React.StrictMode>
    );
  });
});
