import { Component, For } from 'solid-js';
import { createSignal } from 'solid-js';

import styles from './App.module.css';

const App: Component = () => {
	const [files, setFiles] = createSignal([] as string[]);
	let inputRef:any;
	const handleFileEntry = (e:any) => {
		const current = [] as string[];
		Object.keys(inputRef?.files).forEach((key)=>{
			console.log(inputRef.files[key].name)
			current.push(inputRef.files[key].name);
		});
		setFiles(current);
	}
	const handleUpload = () => {
		console.log("Upload Action Performed");
	}


  return (
    <div class={styles.App}>
      <header class={styles.header}>
				<form id="submission-form" method="post" enctype="multipart/form-data" target="api-response" novalidate action={`${window.location.protocol}//${window.location.hostname}:8085/api/files/upload`}>
					<div class={styles.dropZone}>
						<div>
							<label for="uploads">Upload Files</label>
							<div class={styles.dropText}>
								<For each={files()} fallback={null}>
									{(file:string)=><div>{file}</div>}
								</For>
							</div>
						</div>
						<input ref={inputRef} onchange={handleFileEntry} class={styles.hidden} type="file" multiple id="uploads" name="uploads"/>
					</div>
					<input type="submit" id="submit" value="Upload" onClick={handleUpload} class={styles.uploadButton}></input>
				</form>

				<div class={styles.apiResponse}>
					<iframe id="api-response" name="api-response"></iframe>
				</div>
      </header>
    </div>
  );
};

export default App;
