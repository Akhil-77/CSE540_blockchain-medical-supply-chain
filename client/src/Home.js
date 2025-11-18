import React from 'react';
import { useHistory } from 'react-router-dom';

function Home() {
    const history = useHistory();
    const redirect_to_roles = () => { history.push('/roles') }
    const redirect_to_addmed = () => { history.push('/addmed') }
    const redirect_to_supply = () => { history.push('/supply') }
    const redirect_to_track = () => { history.push('/track') }

    return (
        <div>
            <h4>Welcome to PharmaTrace</h4>
            <p>This application demonstrates a transparent and secure pharmaceutical supply chain using blockchain technology.</p>
            
            <hr />

            <h5>Owner Actions</h5>
            <p>The contract owner must register all participants in the supply chain. This is a one-time setup step.</p>
            <button onClick={redirect_to_roles} className="btn btn-primary">Register Participants</button>
            <button onClick={redirect_to_addmed} className="btn btn-primary">Order Drug Batch</button>
            
            <hr style={{marginTop: '2rem', marginBottom: '2rem'}} />

            <h5>Participant Actions</h5>
            <p>Once registered, participants can manage the supply chain by processing drug batches through the various stages.</p>
            <button onClick={redirect_to_supply} className="btn btn-outline-primary">Control Supply Chain</button>

            <hr style={{marginTop: '2rem', marginBottom: '2rem'}} />

            <h5>Track and Verify</h5>
            <p>Anyone can track the journey of a drug batch to verify its authenticity and handling.</p>
            <button onClick={redirect_to_track} className="btn btn-outline-primary">Track Drug Batches</button>
        </div>
    );
}

export default Home;
